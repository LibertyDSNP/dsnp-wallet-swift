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
    let logoutAlertAction = PassthroughSubject<Void, Never>()
    let revealPhraseAction = PassthroughSubject<Void, Never>()
    let toggleFaceIdAction = PassthroughSubject<Bool, Never>()
    
    // App State Settings
    @Published var faceIdEnabled: Bool = AppState.shared.faceIdEnabled()
    @Published var appStateLoggedIn = AppState.shared.isLoggedin

    @Published var shouldRevealPhrase: Int? = 0

    @Published var isAlertPresented = false
    
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
    
    private(set) public var user: User?
    
    // TODO
    var updateUserBlock: ((UserFacadeProtocol)->())?
    
    init(user: User?) {
        self.user = user
        setupObservables()
    }
    
    private func setupObservables() {
        logoutAction
            .sink { [weak self] in
                guard let self else { return }
                self.logout()
                self.isAlertPresented = false
            }
            .store(in: &cancellables)
        logoutAlertAction
            .sink { [weak self] in
                guard let self else { return }
                self.isAlertPresented = true
            }
            .store(in: &cancellables)
        toggleFaceIdAction
            .sink { [weak self] enabled in
                AppState.shared.setFaceIdEnabled(enabled: enabled)
                self?.faceIdEnabled = enabled
            }
            .store(in: &cancellables)
        revealPhraseAction
            .sink { [weak self] in
                guard let self else { return }
                self.isAlertPresented = false
                self.shouldRevealPhrase = 1
            }
            .store(in: &cancellables)
    }
    
    private func logout() {
        AppState.shared.isLoggedin = false
        appStateLoggedIn = false
        do {
            try SeedManager.shared.delete()
            UserDefaults.setHandle(with: "")
        } catch {
            print("error: \(error)")
        }
        try? AccountKeychain.shared.clearAuthorization()
    }
    
    func seed() -> [String] {
        if let seedPhrase = SeedManager.shared.fetch() {
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
