//
//  HomeViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import UIKit
import Combine
import DSNPWallet

enum TabActionError: Error {
    case logoutError
}

class HomeViewModel: ObservableObject {

    // Settings Actions
    let logoutAction = PassthroughSubject<Void, Never>()
    let revealRecoveryAction = PassthroughSubject<Void, Never>()
    let revealPhraseAction = PassthroughSubject<Void, Never>()
    let toggleFaceIdAction = PassthroughSubject<Bool, Never>()
    
    // App State Settings
    @Published var faceIdEnabled: Bool = AppState.shared.faceIdEnabled()
    @Published var appStateLoggedIn = AppState.shared.isLoggedin

    var shouldShowAlert = false
    var chosenHandle: String?

    // Settings - Biometric Device Type String
    var biometricTypeString: String {
        if UIDevice.current.touchIdidentifiers.contains(UIDevice.modelName)  {
            return "Touch ID"
        } else {
            return "Face ID"
        }
    }
    
    private var cancellables = [AnyCancellable]()
    
    // TODO:
    var user: User?
    var updateUserBlock: ((UserFacadeProtocol)->())?
    
    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        logoutAction
            .sink { [weak self] in
                guard let self else { return }
                self.logout()
            }
            .store(in: &cancellables)
        toggleFaceIdAction
            .sink { [weak self] enabled in
                AppState.shared.setFaceIdEnabled(enabled: enabled)
                self?.faceIdEnabled = enabled
            }
            .store(in: &cancellables)
    }
    
    private func logout() {
        appStateLoggedIn = false
        do {
            try? AccountKeychain.shared.clearAuthorization()
        } catch {
            print("error clearing keys")
        }
    }
    
    func seed() -> [String] {
        if let seedPhrase = SeedManager.shared.fetch() {
            print("seed: ", seedPhrase)
            let words = seedPhrase.components(separatedBy: " ")
            return words
        }
        return []
    }
    
    func chosenHandleDisplayString() -> String {
        if let chosenHandle { return chosenHandle }
        return AppState.shared.handle
    }
}
