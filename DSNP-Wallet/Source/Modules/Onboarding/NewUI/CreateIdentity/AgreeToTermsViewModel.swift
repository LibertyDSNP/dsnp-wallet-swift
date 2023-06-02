//
//  AgreeToTermsViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import UIKit
import Combine
import DSNPWallet

class AgreeToTermsViewModel: ObservableObject {
    
    let chosenHandle: String
    
    let agreeAction = PassthroughSubject<Void, Never>()
    
    private var cancellables = [AnyCancellable]()
    
    init(chosenHandle: String) {
        self.chosenHandle = chosenHandle
        setupObservables()
    }
    
    private func setupObservables() {
        agreeAction
            .receive(on: RunLoop.main)
            .sink {
                do {
                    let _ = try DSNPWallet().createKeys()
                } catch {
                    // TODO: Handle error creating keys
                    print("error creating keys")
                }
            }
            .store(in: &cancellables)
    }
}
