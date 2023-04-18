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

class User: UserFacadeProtocol {
    private(set) var publicKey: IRPublicKeyProtocol?
    
    private(set) var name: String?
    private(set) var signer: SigningWrapper?
    
    init(mnemonic: String) {
        guard let keyPair = SeedManager.shared.getKeypair(mnemonic: mnemonic) else { return }
  
        try? AccountKeychain.shared.save(secretKey: keyPair.privateKey().rawData())
        self.publicKey = keyPair.publicKey()
        try? setSigner(publicKeyData: self.publicKey?.rawData())
    }
    
    func set(_ name: String) {
        self.name = name
    }

    func getAddress() -> String? {
        return try? publicKey?.rawData().toAddress(using: .substrate(FrequencyChain.shared.prefixValue))
    }
    
    func getAccountId() -> Data? {
        return try? publicKey?.rawData().publicKeyToAccountId()
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
        
        signer = SigningWrapper(keystore: AccountKeychain.shared.keystore,
                                metaId: address,
                                accountResponse: accountResponse)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
}
