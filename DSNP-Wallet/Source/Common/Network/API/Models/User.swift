//
//  User.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 6/7/22.
//

import Foundation
import DSNPWallet
import SoraKeystore
import IrohaCrypto
import SubstrateSdk

protocol UserFacadeProtocol: AnyObject  {
    var publicKey: IRPublicKeyProtocol? { get }

    var name: String? { get }
    var signer: SigningWrapper? { get }
    
    func getAccountId() -> Data?
    func getAddress() -> String?
}

class User: UserFacadeProtocol, Equatable {
    private let keystore = Keychain() //TODO: This class needs to be global
    private(set) var keypair: IRCryptoKeypairProtocol?
    
    //MARK: User Protocol
    //    private(set) var keys: DSNPKeys? //TODO: Need to implement keys from DSNPWallet Library
    private(set) var publicKey: IRPublicKeyProtocol?
    
    private(set) var name: String?
    private(set) var signer: SigningWrapper?
    
    init(mnemonic: String) {
        self.keypair = SeedManager.shared.getKeypair(mnemonic: mnemonic)
        self.publicKey = keypair?.publicKey()

        try? saveSecretKey(privateKeyData: self.keypair?.privateKey().rawData())
        try? setSigner(publicKeyData: self.publicKey?.rawData())
    }
    
    func set(_ name: String) {
        self.name = name
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
    
    func getAddress() -> String? {
        return try? publicKey?.rawData().toAddress(using: .substrate(FrequencyChain.shared.prefixValue))
    }
    
    func getAccountId() -> Data? {
        return try? publicKey?.rawData().publicKeyToAccountId()
    }
    
    private func saveSecretKey(privateKeyData: Data?) throws {
        guard let privateKeyData = privateKeyData,
            let address = getAddress(),
            let accountId = getAccountId() else {
            throw ExtrinsicError.BadSetup
        }
        
        let tag = KeystoreTagV2.substrateSecretKeyTagForMetaId(address, accountId: accountId)

        try keystore.saveKey(privateKeyData, with: tag)
    }

    private func setSigner(publicKeyData: Data?) throws {
        guard let publicKeyData = publicKeyData,
            let address = getAddress(),
            let accountId = getAccountId() else {
                throw ExtrinsicError.BadSetup
            }
        
        let accountResponse = ChainAccountResponse(chainId: FrequencyChain.shared.id,
                                                   accountId: accountId,
                                                   publicKey: publicKeyData,
                                                   name: FrequencyChain.shared.chainName,
                                                   cryptoType: FrequencyChain.shared.cryptoType,
                                                   addressPrefix: FrequencyChain.shared.prefixValue,
                                                   isEthereumBased: false,
                                                   isChainAccount: true)
        
        signer = SigningWrapper(keystore: keystore,
                                metaId: address,
                                accountResponse: accountResponse)
    }
}
