//
//  EnterPinViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/13/22.
//

import Foundation
import UIKit
import DSNPWallet
import LocalAuthentication

class EnterPinViewController: SharedStackViewController {

    public var didSucceed:(() -> Void)?
    public var didCancel:(() -> Void)?
    
    private var pinIsSet: Bool { return !(AccountKeychain.shared.accessPin?.isEmpty ?? true) }
    private var loadingAlertController: SharedLoadingAlertController?
    private var viewModel: EnterPin_BaseViewModel?
    private let keys: DSNPKeys

    init(keys: DSNPKeys) {
        self.keys = keys
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingAlertController = SharedLoadingAlertController(parent: self)
        self.backButton?.isHidden = true
        
        self.viewModel =  self.pinIsSet ?
            EnterPin_ValidatePinViewModel() :
            EnterPin_SetupPinViewModel()
        self.viewModel?.didSucceed = { [weak self] in
            guard let self = self else { return }
            self.login()
        }
        self.viewModel?.didCancel = { [weak self] in
            guard let self = self else { return }
            self.didCancel?()
        }
        self.scrollableStackView?.replaceViews(self.viewModel?.stackViews())
        
        if self.pinIsSet {
            self.biometricAuth()
        }
    }
    
    private func login() {
        self.loadingAlertController?.presentLoadingView(title: "Authenticating...")
//        AccountAPI.shared.refreshAccessToken {
            DispatchQueue.main.async {
                self.loadingAlertController?.dismissLoadingView(completion: {
                    self.didSucceed?()
                })
            }
//        } didCompleteWithError: { error in
//            DispatchQueue.main.async {
//                self.loadingAlertController?.dismissLoadingView(completion: {
//                    self.didCancel?()
//                })
//            }
//        }
    }
    
    private func biometricAuth() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // User authenticated successfully, proceed with desired action
                        self.didSucceed?()
                    } else {
                        // Authentication failed, display error message
//                        self.didCancel?()
                    }
                }
            }
        } else {
            // Biometric authentication not available on this device
//            self.didCancel?()
        }
    }
}
