//
//  SeedManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 3/22/23.
//

import SoraKeystore
import IrohaCrypto
import SubstrateSdk

//TODO: Migrate this to DSNPWallet?
class SeedManager {
    static let shared = SeedManager()
    
    func generateMnemonic() -> String? {
        guard let result = generateSeed() else { return nil }
        
        return result.mnemonic.toString()
    }
    
    func getKeypair(mnemonic: String) -> IRCryptoKeypairProtocol? {
        let seedFactory = SeedFactory(mnemonicLanguage: .english)

        guard let seedResult = try? seedFactory.deriveSeed(from: mnemonic, password: "") else {
            return nil
        }

        let keypair = try? SR25519KeypairFactory().createKeypairFromSeed(
            seedResult.seed.miniSeed,
            chaincodeList: []
        )

        return keypair
    }
    
    private func generateSeed() -> SeedFactoryResult? {
        let seedFactory = SeedFactory(mnemonicLanguage: .english)

        return try? seedFactory.createSeed(from: "", strength: .entropy128)
    }
}
