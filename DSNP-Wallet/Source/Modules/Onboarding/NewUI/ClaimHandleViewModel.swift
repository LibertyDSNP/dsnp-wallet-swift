//
//  ClaimHandleViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/5/23.
//

import UIKit
import Combine

enum ClaimHandleError: String {
    case handleTooShortError = "Your handle must be at least 4 characters"
    case handleTooLongError = "Your handle cannot be more than 16 characters"
}

class ClaimHandleViewModel: ObservableObject {
    @Published var claimHandleText = ""
    @Published var nextButtonDisabled = true
    @Published var errorMessage: String = ""
    
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
                    
                    // Upper limit is 16, lower limit is 4
                    self.nextButtonDisabled = self.claimHandleText.count >= 4 || self.claimHandleText.count > 16
                    self.errorMessage = {
                        if self.claimHandleText.count < 4 {
                            self.errorMessage = ClaimHandleError.handleTooShortError.rawValue
                        } else if self.claimHandleText.count > 16 {
                            self.errorMessage = ClaimHandleError.handleTooLongError.rawValue
                        }
                        return ""
                    }()
                }
            }
            .store(in: &cancellables)
    }
    
}
