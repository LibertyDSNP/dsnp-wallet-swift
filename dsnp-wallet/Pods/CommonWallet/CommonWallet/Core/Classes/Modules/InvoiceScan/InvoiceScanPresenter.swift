/**
* Copyright Soramitsu Co., Ltd. All Rights Reserved.
* SPDX-License-Identifier: GPL-3.0
*/

import Foundation
import AVFoundation
import SoraFoundation
import RobinHood

final class InvoiceScanPresenter {
    enum ScanState {
        case initializing(accessRequested: Bool)
        case inactive
        case active
    }

    struct ProcessingInfo {
        let receiveInfo: ReceiveInfo
        let operation: CancellableCall
    }

    weak var view: InvoiceScanViewProtocol?
    var coordinator: InvoiceScanCoordinatorProtocol

    var logger: WalletLoggerProtocol?

    private(set) var networkService: WalletServiceProtocol
    private(set) var currentAccountId: String
    private(set) var scanState: ScanState = .initializing(accessRequested: false)

    private let qrScanService: WalletQRCaptureServiceProtocol
    private let qrCoderFactory: WalletQRCoderFactoryProtocol
    private let qrScanMatcher: InvoiceScanMatcher
    private let localSearchEngine: InvoiceLocalSearchEngineProtocol?

    var qrExtractionService: WalletQRExtractionServiceProtocol?

    private var localizationManager: LocalizationManagerProtocol?

    private var processingInfo: ProcessingInfo?

    init(view: InvoiceScanViewProtocol,
         coordinator: InvoiceScanCoordinatorProtocol,
         currentAccountId: String,
         networkService: WalletServiceProtocol,
         localSearchEngine: InvoiceLocalSearchEngineProtocol?,
         qrScanServiceFactory: WalletQRCaptureServiceFactoryProtocol,
         qrCoderFactory: WalletQRCoderFactoryProtocol,
         localizationManager: LocalizationManagerProtocol?) {
        self.view = view
        self.coordinator = coordinator
        self.networkService = networkService
        self.localSearchEngine = localSearchEngine
        self.currentAccountId = currentAccountId

        self.qrCoderFactory = qrCoderFactory

        let qrDecoder = qrCoderFactory.createDecoder()
        self.qrScanMatcher = InvoiceScanMatcher(decoder: qrDecoder)

        self.localizationManager = localizationManager

        self.qrScanService = qrScanServiceFactory.createService(with: qrScanMatcher,
                                                                delegate: nil,
                                                                delegateQueue: nil)

        self.qrScanService.delegate = self
    }

    private func handleQRService(error: Error) {
        if let captureError = error as? WalletQRCaptureServiceError {
            handleQRCaptureService(error: captureError)
            return
        }

        if let extractionError = error as? WalletQRExtractionServiceError {
            handleQRExtractionService(error: extractionError)
            return
        }

        if let imageGalleryError = error as? ImageGalleryError {
            handleImageGallery(error: imageGalleryError)
        }

        logger?.error("Unexpected qr service error \(error)")
    }

    private func handleQRCaptureService(error: WalletQRCaptureServiceError) {
        guard case .initializing(let alreadyAskedAccess) = scanState, !alreadyAskedAccess else {
            logger?.warning("Requested to ask access but already done earlier")
            return
        }

        scanState = .initializing(accessRequested: true)

        switch error {
        case .deviceAccessRestricted:
            view?.present(message: L10n.InvoiceScan.Error.cameraRestricted, animated: true)
        case .deviceAccessDeniedPreviously:
            let message = L10n.InvoiceScan.Error.cameraRestrictedPreviously
            let title = L10n.InvoiceScan.Error.cameraTitle
            coordinator.askOpenApplicationSettings(with: message, title: title, from: view)
        default:
            break
        }
    }

    private func handleQRExtractionService(error: WalletQRExtractionServiceError) {
        switch error {
        case .noFeatures:
            view?.present(message: L10n.InvoiceScan.Error.noInfo, animated: true)
        case .detectorUnavailable, .invalidImage:
            view?.present(message: L10n.InvoiceScan.Error.invalidImage, animated: true)
        }
    }

    private func handleImageGallery(error: ImageGalleryError) {
        switch error {
        case .accessRestricted:
            view?.present(message: L10n.InvoiceScan.Error.galleryRestricted, animated: true)
        case .accessDeniedPreviously:
            let message = L10n.InvoiceScan.Error.galleryRestrictedPreviously
            let title = L10n.InvoiceScan.Error.galleryTitle
            coordinator.askOpenApplicationSettings(with: message, title: title, from: view)
        default:
            break
        }
    }

    private func handleReceived(captureSession: AVCaptureSession) {
        if case .initializing = scanState {
            scanState = .active

            view?.didReceive(session: captureSession)
        }
    }

    private func handleGalleryMatched(receiverInfo: ReceiveInfo) {
        if receiverInfo.accountId == currentAccountId {
            let message = L10n.InvoiceScan.Error.match
            view?.present(message: message, animated: true)
            return
        }

        if let processingInfo = processingInfo {
            guard processingInfo.receiveInfo != receiverInfo else {
                return
            }

            self.processingInfo?.operation.cancel()
            self.processingInfo = nil
        }

        performProcessing(of: receiverInfo)
    }

    private func handleScanMatched(receiverInfo: ReceiveInfo) {
        if receiverInfo.accountId == currentAccountId {
            let message = L10n.InvoiceScan.Error.match
            view?.present(message: message, animated: true)
            return
        }

        if let processingInfo = processingInfo {
            guard processingInfo.receiveInfo != receiverInfo else {
                return
            }

            self.processingInfo?.operation.cancel()
            self.processingInfo = nil
        }

        switch scanState {
        case .active:
            performProcessing(of: receiverInfo)
        case .inactive, .initializing:
            break
        }
    }

    private func handleFailedMatching(for code: String) {
        let message = L10n.InvoiceScan.Error.extractFail
        view?.present(message: message, animated: true)
    }

    private func performProcessing(of receiverInfo: ReceiveInfo) {
        if let searchData = localSearchEngine?.searchByAccountId(receiverInfo.accountId) {
            processingInfo = nil

            completeTransferFoundAccount(searchData, receiverInfo: receiverInfo)
        } else {
            let operation = networkService.search(for: receiverInfo.accountId,
                                                  runCompletionIn: .main) { [weak self] (optionalResult) in
                                                    if let result = optionalResult {
                                                        switch result {
                                                        case .success(let searchResult):
                                                            let loadedResult = searchResult ?? []
                                                            self?.handleProccessing(searchResult: loadedResult)
                                                        case .failure(let error):
                                                            self?.handleProcessing(error: error)
                                                        }
                                                    }
            }

            processingInfo = ProcessingInfo(receiveInfo: receiverInfo, operation: operation)
        }
    }

    private func handleProccessing(searchResult: [SearchData]) {
        guard let receiverInfo = processingInfo?.receiveInfo else {
            logger?.warning("Unexpected state info after successfull processing")
            return
        }

        self.processingInfo = nil

        guard let foundAccount = searchResult.first else {
            let message = L10n.InvoiceScan.Error.userNotFound
            view?.present(message: message, animated: true)
            return
        }

        completeTransferFoundAccount(foundAccount, receiverInfo: receiverInfo)
    }

    private func completeTransferFoundAccount(_ foundAccount: SearchData,
                                              receiverInfo: ReceiveInfo) {
        guard foundAccount.accountId == receiverInfo.accountId else {
                let message = L10n.InvoiceScan.Error.noReceiver
                view?.present(message: message, animated: true)
                return
        }

        let receiverName = "\(foundAccount.firstName) \(foundAccount.lastName)"
        let payload = TransferPayload(receiveInfo: receiverInfo,
                                      receiverName: receiverName)

        coordinator.process(payload: payload)
    }

    private func handleProcessing(error: Error) {
        guard processingInfo != nil else {
            logger?.warning("Unexpected state \(scanState) after failed processing")
            return
        }

        self.processingInfo = nil

        if let contentConvertible = error as? WalletErrorContentConvertible {
            let locale = localizationManager?.selectedLocale
            let content = contentConvertible.toErrorContent(for: locale)
            view?.present(message: content.message, animated: true)
        } else {
            let message = L10n.InvoiceScan.Error.noInternet
            view?.present(message: message, animated: true)
        }

    }
}

extension InvoiceScanPresenter: InvoiceScanPresenterProtocol {
    func prepareAppearance() {
        qrScanService.start()
    }

    func handleAppearance() {
        if case .inactive = scanState {
            scanState = .active
        }
    }

    func prepareDismiss() {
        if case .initializing = scanState {
            return
        }

        processingInfo?.operation.cancel()
        processingInfo = nil

        scanState = .inactive
    }

    func handleDismiss() {
        qrScanService.stop()
    }

    func activateImport() {
        if qrExtractionService != nil {
            coordinator.presentImageGallery(from: view, delegate: self)
        }
    }
}

extension InvoiceScanPresenter: WalletQRCaptureServiceDelegate {
    func qrCapture(service: WalletQRCaptureServiceProtocol, didSetup captureSession: AVCaptureSession) {
        DispatchQueue.main.async {
            self.handleReceived(captureSession: captureSession)
        }
    }

    func qrCapture(service: WalletQRCaptureServiceProtocol, didMatch code: String) {
        guard let receiverInfo = qrScanMatcher.receiverInfo else {
            logger?.warning("Can't find receiver's info for matched code")
            return
        }

        DispatchQueue.main.async {
            self.handleScanMatched(receiverInfo: receiverInfo)
        }
    }

    func qrCapture(service: WalletQRCaptureServiceProtocol, didFailMatching code: String) {
        DispatchQueue.main.async {
            self.handleFailedMatching(for: code)
        }
    }

    func qrCapture(service: WalletQRCaptureServiceProtocol, didReceive error: Error) {
        DispatchQueue.main.async {
            self.handleQRService(error: error)
        }
    }
}

extension InvoiceScanPresenter: ImageGalleryDelegate {
    func didCompleteImageSelection(from gallery: ImageGalleryPresentable,
                                   with selectedImages: [UIImage]) {
        if let image = selectedImages.first {
            let qrDecoder = qrCoderFactory.createDecoder()
            let matcher = InvoiceScanMatcher(decoder: qrDecoder)

            qrExtractionService?.extract(from: image,
                                         using: matcher,
                                         dispatchCompletionIn: .main) { [weak self] result in
                switch result {
                case .success:
                    if let recieverInfo = matcher.receiverInfo {
                        self?.handleGalleryMatched(receiverInfo: recieverInfo)
                    }
                case .failure(let error):
                    self?.handleQRService(error: error)
                }
            }
        }
    }

    func didFail(in gallery: ImageGalleryPresentable, with error: Error) {
        handleQRService(error: error)
    }
}
