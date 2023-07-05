//
//  AgreeToTermsViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import UIKit
import Combine

class AgreeToTermsViewModel: ObservableObject {
    
    let chosenHandle: String
    
    let agreeAction = PassthroughSubject<Void, Never>()
    
    private var cancellables = [AnyCancellable]()
    
    @Published var shouldPush: Int? = 0

    // User created from seed phrase
    @Published var user: User?
    
    
    init(chosenHandle: String) {
        self.chosenHandle = chosenHandle
        setupObservables()
    }
    
    private func setupObservables() {
        agreeAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                AppState.shared.isLoggedin = true
                UserDefaults.setHandle(with: self.chosenHandle)
                
                if let seed = SeedManager.shared.generateMnemonic() {
                    // Check if seed saves successfully
                    if !self.saveSeed(seed: seed) {
                        // TODO: Handle Error
                        return
                    }

                    do {
                        self.user = try User(mnemonic: seed)
                        self.shouldPush = 1
                    } catch {
                        // TODO: Handle Error
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveSeed(seed: String) -> Bool {
        do {
            try SeedManager.shared.save(seed)
            return true
        } catch let error as SeedManagerError {
            print("error saving seed: ", error)
        } catch {
            print(error)
        }
        return false
    }
}
