//
//  ImportSeedViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/28/23.
//

import UIKit
import Combine

enum ImportSeedState {
    case error, editing
}

class ImportSeedViewModel: ObservableObject {
    /// Seed Phrase Text
    @Published var seedPhraseText = ""
    
    // View reads from this, changed pending validation on the seed phrase field
    @Published var textfieldDisabled: Bool = true
    
    @Published var state: ImportSeedState = .editing
    @Published var shouldPush: Int? = 0
    
    // User created from seed phrase
    @Published var user: User?
    
    // Actions
    let submitAction = PassthroughSubject<Void, Never>()
    
    private var cancellables = [AnyCancellable]()
    
    private var validCharSet: CharacterSet = {
        let charSetAlphaNumerics = CharacterSet.letters
        let spaces = CharacterSet(charactersIn: " ")
        return charSetAlphaNumerics.union(spaces)
    }()
    
    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        $seedPhraseText
            .receive(on: RunLoop.main)
            .sink { [weak self] inputText in
                guard let self else { return }
                //check if the text contains any invalid characters
                if inputText.rangeOfCharacter(from: self.validCharSet.inverted) == nil {
                    self.seedPhraseText = String(self.seedPhraseText.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                }
                self.textfieldDisabled = {
                    // check number of words
                    if inputText.components(separatedBy: " ").count > 11 {
                        return false
                    }
                    return true
                }()
            }
            .store(in: &cancellables)
        submitAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                guard SeedManager.shared.getKeypair(mnemonic: self.seedPhraseText) != nil else {
                    print("could not find that account!")
                    self.seedPhraseText = ""
                    self.state = .error
                    return
                    // TODO: Present Error Toast
                }
                // TODO: SAVE USER, PRESENT TAB VIEW Controller
                print("Seed phrase found!")
                do {
                    try SeedManager.shared.save(self.seedPhraseText)
                    self.user = try User(mnemonic: self.seedPhraseText)
                    self.shouldPush = 1
                } catch {
                    // TODO: Error Handling
                }
            }
            .store(in: &cancellables)
    }
    
}

