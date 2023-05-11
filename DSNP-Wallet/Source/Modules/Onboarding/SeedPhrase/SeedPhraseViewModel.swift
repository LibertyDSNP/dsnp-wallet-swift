//
//  SeedPhraseViewModel.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/9/23.
//

import Foundation
import SoraKeystore

class SeedPhraseViewModel {
    var seedPhrase: String?
    var keychainManager = KeychainManager.shared
    
    init() {
        guard let mnemonic = SeedManager.shared.generateMnemonic() else { return }
        seedPhrase = mnemonic
    }
    
    func save(mnemonic: String) {
        try? AccountKeychain.shared.save(mnemonic: mnemonic)
    }
}
