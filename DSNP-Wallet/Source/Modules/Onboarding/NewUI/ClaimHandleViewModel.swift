//
//  ClaimHandleViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/5/23.
//

import UIKit
import Combine

class ClaimHandleViewModel: ObservableObject {
    @Published var claimHandleText = ""
    @Published var nextButtonDisabled = true
    
    // Actions
    var nextAction = PassthroughSubject<Void, Never>()
    
    private var cancellables = [AnyCancellable]()
    private var validCharSet = CharacterSet.alphanumerics

    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        $claimHandleText
            .receive(on: RunLoop.main)
            .sink { [weak self] inputText in
                guard let self else { return }
                //check if the new string contains any invalid characters
                if inputText.rangeOfCharacter(from: self.validCharSet.inverted) != nil {
                    self.claimHandleText = String(self.claimHandleText.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                    self.nextButtonDisabled = !self.claimHandleText.isEmpty
                }
            }
            .store(in: &cancellables)
    }
    
}
