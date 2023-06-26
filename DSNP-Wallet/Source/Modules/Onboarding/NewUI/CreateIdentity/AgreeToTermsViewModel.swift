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
    let backAction = PassthroughSubject<Void, Never>()
    
    private var cancellables = [AnyCancellable]()
    
    init(chosenHandle: String) {
        self.chosenHandle = chosenHandle
        setupObservables()
    }
    
    private func setupObservables() {
        agreeAction
            .receive(on: RunLoop.main)
            .sink {
                if let seed = SeedManager.shared.generateMnemonic() {
                    SeedManager.shared.save(seed)
                }
                AppState.shared.setHandle(handle: self.chosenHandle)
            }
            .store(in: &cancellables)
    }
}
