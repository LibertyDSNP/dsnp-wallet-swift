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
    let backAction = PassthroughSubject<Void, Never>()
    
    private var cancellables = [AnyCancellable]()
    
    init(chosenHandle: String) {
        self.chosenHandle = chosenHandle
        setupObservables()
    }
    
    private func setupObservables() {
        agreeAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                do {
                    let _ = try DSNPWallet().createKeys()
                    AppState.shared.setHandle(handle: self.chosenHandle)
                    
                    // Update social progress state
                    let socialProgressState = SocialIdentityProgressState(isHandleCreated: !self.chosenHandle.isEmpty)
                    AppState.shared.setSocialIdentityProgressState(state: socialProgressState)
                    
                } catch {
                    // TODO: Handle error creating keys
                    print("error creating keys")
                }
            }
            .store(in: &cancellables)
    }
}
