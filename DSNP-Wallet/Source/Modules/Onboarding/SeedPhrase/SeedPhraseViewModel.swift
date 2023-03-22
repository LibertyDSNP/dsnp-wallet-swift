//
//  SeedPhraseViewModel.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/9/23.
//

import Foundation
import SoraKeystore

class SeedPhraseViewModel {
    var seedPhraseWords: [String] = []
    var keychainManager = KeychainManager.shared
    
    init() {
        guard let mnemonic = SeedManager.shared.generateMnemonic() else { return }
        seedPhraseWords = mnemonic.components(separatedBy: " ")
    }
}
