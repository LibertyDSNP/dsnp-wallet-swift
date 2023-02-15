//
//  TestViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 10/12/22.
//

import UIKit
import SoraKeystore
import BigInt
import IrohaCrypto

import RobinHood
import SubstrateSdk

enum TestError: Error {
    case BadSetup
    case BadKeys
    case BadSignature
    case BadAccountId
    case BadExtrinsic
}

class TestViewController: UIViewController {
    
    let keystore = Keychain()
    
    //MARK: Chain Constants
    let chainId = "496e2f8a93bf4576317f998d01480f9068014b368856ec088a63e57071cd1d49"
    let frequencyPrefixValue: UInt16 = 42
    
    //MARK: Account Constants
    let aliceAddress = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"
    let bobAddress = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty"

    let primaryAddress = "5FxxBckLfzKYA42vsj7tihMMrUY7tF7mGk5Asez7JfRPsAsw"
    let primaryMnemonic = "quote grocery buzz staff merit patch outdoor depth eight raw rubber once"
    
    let secondaryAddress = "5DbvWVBoNSjWcQufNQMNJHxWiHGcAdcLX3QEFn6WCd6BBuG7"
    let secondaryMnemonic = "rifle hub give speak sorry hurt bread shaft ahead whale scatter sleep"
    
    //MARK: Variables
    var extrinsicService: ExtrinsicService?
    let callFactory: SubstrateCallFactory = SubstrateCallFactory()
    
    var primarySigner: SigningWrapper?
    var secondarySigner: SigningWrapper?
    
    var primaryAccountId: Data!
    var secondaryAccountId: Data!
    
    var primaryKeyPair: IRCryptoKeypairProtocol!
    var secondaryKeyPair: IRCryptoKeypairProtocol!
    
    override func viewDidLoad() {
        primaryAccountId = try? primaryAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        secondaryAccountId = try? secondaryAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        
        try? setAccounts()
        try? setExtrinsicService(with: primaryAccountId)
        
//        try? CreateMSA()
//        try? AddPublicKeyToMsa()
//        try? Transfer(amount: 100000000, toAccountId: secondaryAccountId)
    }
    
    func CreateMSA() throws {
        let closure: ExtrinsicBuilderClosure = { builder in
            let call = self.callFactory.createMsa()
            _ = try builder.adding(call: call)
            return builder
        }
        
        guard let signer = primarySigner else { throw TestError.BadSetup }
        
        extrinsicService?.submit(closure,
                                 signer: signer,
                                 runningIn: .main) { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func Transfer(amount: BigUInt, toAccountId: AccountId) throws {
        let closure: ExtrinsicBuilderClosure = { builder in
            let call = self.callFactory.nativeTransfer(to: toAccountId, amount: amount)
            _ = try builder.adding(call: call)
            return builder
        }
        
        guard let signer = primarySigner else { throw TestError.BadSetup }
        
        extrinsicService?.submit(closure,
                                 signer: signer,
                                 runningIn: .main) { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func AddPublicKeyToMsa() throws {
        guard let primarySigner = primarySigner,
              let secondarySigner = secondarySigner else { throw TestError.BadSetup }
        
        guard let primaryPublicKeyData = primaryKeyPair?.publicKey().rawData() else { throw TestError.BadKeys }
        
        guard let secondaryAccountId = secondaryAccountId else { throw TestError.BadAccountId }
        
        let addKeyPayload = AddKeyPayloadArg(msaId: 1,
                                             expiration: 5,
                                             newPublicKey: secondaryAccountId)

        guard let keyPayloadData = try? JSONEncoder().encode(addKeyPayload) else { return }
        
        let msaOwnerRawSignature = try primarySigner.sign(keyPayloadData).rawData()
        let newOwnerRawSignature = try secondarySigner.sign(keyPayloadData).rawData()
        let msaOwnerSignature = MultiSignature.sr25519(data: msaOwnerRawSignature)
        let newOwnerSignature = MultiSignature.sr25519(data: newOwnerRawSignature)

        let closure: ExtrinsicBuilderClosure = { builder in
            let call = self.callFactory.addPublicKeyToMsa(msaOwnerPublicKey: primaryPublicKeyData,
                                                          msaOwnerProof: msaOwnerSignature,
                                                          newKeyOwnerProof: newOwnerSignature,
                                                          addKeyPayload: addKeyPayload)
            _ = try builder.adding(call: call)
            return builder
        }

        extrinsicService?.submit(closure,
                                 signer: primarySigner,
                                 runningIn: .main) { result in
            switch result {
            case .success(let result):
                print("RESULT: SUCCESS\(result)")
            case .failure(let error):
                print("RESULT: FAILURE \(error)")
            }
        }
    }
    
    func StorageQuery() {
        
    }
}

//MARK: Helper Funcs for Setup
extension TestViewController {
    private func setExtrinsicService(with senderId: Data) throws {
        let chainRegistry = ChainRegistryFactory.createDefaultRegistry()
        
        let serviceCoordinator = ServiceCoordinator.createDefault()
        serviceCoordinator.setup()
        
        guard let chain = chainRegistry.getChain(for: chainId),
              let connection = chainRegistry.getConnection(for: chainId),
              let runtimeService = chainRegistry.getRuntimeProvider(for: chainId) else {
            throw TestError.BadSetup
        }
        let operationManager = OperationManager(operationQueue: .main)
        
        extrinsicService = ExtrinsicService(accountId: senderId,
                                            chain: chain,
                                            cryptoType: .sr25519,
                                            runtimeRegistry: runtimeService,
                                            engine: connection,
                                            operationManager: operationManager)
    }
    
    private func setSigner(with accountId: AccountId, metaId: String, publicKey: Data) -> SigningWrapper {
        let accountResponse = ChainAccountResponse(chainId: chainId,
                                                   accountId: accountId,
                                                   publicKey: publicKey,
                                                   name: "Freq",
                                                   cryptoType: .sr25519,
                                                   addressPrefix: frequencyPrefixValue,
                                                   isEthereumBased: false,
                                                   isChainAccount: true)
        return SigningWrapper(keystore: keystore,
                              metaId: metaId,
                              accountResponse: accountResponse)
    }
}

//MARK: Key Management
extension TestViewController {
    private func saveSecretKey(
        _ secretKey: Data,
        metaId: String,
        accountId: AccountId,
        ethereumBased: Bool
    ) throws {
        let tag = ethereumBased ?
            KeystoreTagV2.ethereumSecretKeyTagForMetaId(metaId, accountId: accountId) :
            KeystoreTagV2.substrateSecretKeyTagForMetaId(metaId, accountId: accountId)

        try keystore.saveKey(secretKey, with: tag)
    }
    
    private func getKeypair(with mnemonic: String) -> IRCryptoKeypairProtocol? {
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
    
    private func setAccounts() throws {
        primaryKeyPair = getKeypair(with: primaryMnemonic)
        secondaryKeyPair = getKeypair(with: secondaryMnemonic)
        
        guard let primaryPublicKeyData = primaryKeyPair?.publicKey().rawData(),
              let secondaryPublicKeyData = secondaryKeyPair?.publicKey().rawData() else { throw TestError.BadKeys }
        
        guard let primaryPrivateKeyData = primaryKeyPair?.privateKey().rawData(),
              let secondaryPrivateKeyData = secondaryKeyPair?.privateKey().rawData() else { throw TestError.BadKeys }
        
        guard let primaryAccountId = primaryAccountId,
              let secondaryAccountId = secondaryAccountId else { throw TestError.BadAccountId }
        
        primarySigner = setSigner(with: primaryAccountId, metaId: primaryAddress, publicKey: primaryPublicKeyData)
        secondarySigner = setSigner(with: secondaryAccountId, metaId: secondaryAddress, publicKey: secondaryPublicKeyData)
        
        try saveSecretKey(primaryPrivateKeyData, metaId: primaryAddress, accountId: primaryAccountId, ethereumBased: false)
        try saveSecretKey(secondaryPrivateKeyData, metaId: secondaryAddress, accountId: secondaryAccountId, ethereumBased: false)
    }
}
