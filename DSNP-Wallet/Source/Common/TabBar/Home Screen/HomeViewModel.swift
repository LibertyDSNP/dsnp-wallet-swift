//
//  HomeViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import UIKit
import Combine

enum TabActionError: Error {
    case logoutError
}

class HomeViewModel: ObservableObject {

    let logoutAction = PassthroughSubject<Void, Never>()
    
    @Published var appStateLoggedIn = AppState.shared.isLoggedin

    private var cancellables = [AnyCancellable]()
    
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
    }
    
    private func logout() {
        appStateLoggedIn = false
        do {
            try AuthManager.shared.logout()
        } catch {
            print("error clearing keys")
        }
    }
}
