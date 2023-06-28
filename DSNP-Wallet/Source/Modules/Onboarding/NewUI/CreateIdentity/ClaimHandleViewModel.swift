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
    var skipAction = PassthroughSubject<Void, Never>()
    
    private var cancellables = [AnyCancellable]()
    
    // Claim handle field
    private var validCharSet: CharacterSet = {
        let charSetAlphaNumerics = CharacterSet.alphanumerics
        let underscores = CharacterSet(charactersIn: "_")
        return charSetAlphaNumerics.union(underscores)
    }()
    private let minimumStringCount = 4
    private let maxStringCount = 16

    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        $claimHandleText
            .receive(on: RunLoop.main)
            .sink { [weak self] inputText in
                guard let self else { return }
                //check if the new string contains any invalid characters
                if inputText.rangeOfCharacter(from: self.validCharSet.inverted) == nil {
                    self.claimHandleText = String(self.claimHandleText.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                    
                    if self.claimHandleText.count > self.maxStringCount {
                        let index = self.claimHandleText.index(self.claimHandleText.startIndex, offsetBy: self.maxStringCount)
                        self.claimHandleText = String(self.claimHandleText[..<index])
                    }
                    
                    // Upper limit is 16, lower limit is 4
                    self.nextButtonDisabled = self.claimHandleText.count < self.minimumStringCount || self.claimHandleText.count > self.maxStringCount
                }
            }
            .store(in: &cancellables)
    }
    
}
