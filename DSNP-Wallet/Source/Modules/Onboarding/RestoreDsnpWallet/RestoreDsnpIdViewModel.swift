//
//  RestoreDsnpIdViewModel.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 3/16/23.
//

import Foundation
import DSNPWallet
import IrohaCrypto

class RestoreDsnpIdViewModel {
    func submit(mnemonic: String) throws -> IRCryptoKeypairProtocol?  {
        let keypair = SeedManager.shared.getKeypair(mnemonic: mnemonic)
        
        return keypair
    }
}
