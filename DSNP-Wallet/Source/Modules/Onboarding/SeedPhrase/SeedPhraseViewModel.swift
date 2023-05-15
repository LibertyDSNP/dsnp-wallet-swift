//
//  SeedPhraseViewModel.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/9/23.
//

import Foundation
import Combine

class SeedPhraseViewModel {
    
    let testAction = PassthroughSubject<Void, Never>()
    
    let seedPhraseWords: [String]
    
    init(seedPhraseWords: [String]) {
        self.seedPhraseWords = seedPhraseWords
    }
}
