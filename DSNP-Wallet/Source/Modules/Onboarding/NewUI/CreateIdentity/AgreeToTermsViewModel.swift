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
    
    private(set) public var user: User?
    
    init(chosenHandle: String) {
        self.chosenHandle = chosenHandle
        setupObservables()
    }
    
    private func setupObservables() {
        agreeAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                if let seed = SeedManager.shared.generateMnemonic() {
                    SeedManager.shared.save(seed)
                    self.user = User(mnemonic: seed)
                }
                AppState.shared.setHandle(handle: self.chosenHandle)
            }
            .store(in: &cancellables)
    }
}
