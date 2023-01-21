//
//  ExtrinsicTest.swift
//  DSNP-WalletTests
//
//  Created by Ryan Sheh on 1/18/23.
//

import XCTest
import SoraKeystore
import BigInt
import IrohaCrypto

import RobinHood
import SubstrateSdk
@testable import DSNP_Wallet

import XCTest

//MARK: Figure this out
struct Currency {
    var units = 100000000
    var dollars = 1000000
    var cents = 1000
    var millicents = 1
}

class ExtrinsicTest: XCTestCase {
    let chainId = "496e2f8a93bf4576317f998d01480f9068014b368856ec088a63e57071cd1d49"
    let finalizedBlockHash = "0x19b40c89e73be7a18addb8f2825e7ee00ab38d8ec24073976c1a017e2e918f51"
    
    let aliceAddress = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"
    let bobAddress = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty"
    let testAddress = "5FxxBckLfzKYA42vsj7tihMMrUY7tF7mGk5Asez7JfRPsAsw" //"third" address
    let secondTestAddress = "5FF2rYk6NCBpHAYjjE2RTQutVHK5BTGoBtcdvU3SQGxz4sZx"
    
    var aliceAccountId: Data!
    var bobAccountId: Data!
    var testAccountId: Data!
    var secondTestAccountId: Data!
    
    let frequencyPrefixValue: UInt16 = 42
    
    let seedPhrase = "quote grocery buzz staff merit patch outdoor depth eight raw rubber once" //"third" account
    
    override func setUpWithError() throws {
        aliceAccountId = try aliceAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        bobAccountId = try bobAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        testAccountId = try testAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        secondTestAccountId = try secondTestAddress.toAccountId(using: .substrate(frequencyPrefixValue))
    }

    override func tearDownWithError() throws {
        
    }
    
    func testTransfer() throws {
        let receiverId: Data = secondTestAccountId//bobAccountId
        let senderId: Data = testAccountId
        
        let chainRegistry = ChainRegistryFactory.createDefaultRegistry()
        
        let serviceCoordinator = ServiceCoordinator.createDefault()
        serviceCoordinator.setup()
        
        guard let chain = chainRegistry.getChain(for: chainId),
              let connection = chainRegistry.getConnection(for: chainId),
              let runtimeService = chainRegistry.getRuntimeProvider(for: chainId) else { return }
        let operationManager = OperationManager(operationQueue: .main)

        let extrinsicService = ExtrinsicService(accountId: senderId,
                                                chain: chain,
                                                cryptoType: .sr25519,
                                                runtimeRegistry: runtimeService,
                                                engine: connection,
                                                operationManager: operationManager)
        
        //RyanKeyManager hardcode grabs publicKey of testAccountId
        let keyManager = RyanKeyManager()
        let keypair = keyManager.getKeypair()
        guard let publicKey = keypair?.publicKey().rawData() else { return }

        let closure = createExtrinsicBuilderClosure(accountId: receiverId, amount: 100000000) //receiver
        let accountResponse = ChainAccountResponse(chainId: chainId,
                                                   accountId: senderId,
                                                   publicKey: publicKey,
                                                   name: "Ryan",
                                                   cryptoType: .sr25519,
                                                   addressPrefix: 42,
                                                   isEthereumBased: false,
                                                   isChainAccount: false)
        
        let signer = SigningWrapper(keystore: RyanKeyManager(),
                                    metaId: "",
                                    accountResponse: accountResponse)
        
        let feeExpectation = XCTestExpectation()
        extrinsicService.submit(closure,
                                signer: signer,
                                runningIn: .main) { result in
            print("RYAN: \(result)")
            feeExpectation.fulfill()
        }
        
        wait(for: [feeExpectation], timeout: 10)
    }
    
    private func createExtrinsicBuilderClosure(accountId: AccountId, amount: BigUInt) -> ExtrinsicBuilderClosure {
        let callFactory = SubstrateCallFactory()
        
        let closure: ExtrinsicBuilderClosure = { builder in
            let call = callFactory.nativeTransfer(to: accountId, amount: amount)
            _ = try builder.adding(call: call)
            return builder
        }
        
        return closure
    }
}

class RyanKeyManager: KeystoreProtocol {
    func addKey(_ key: Data, with identifier: String) throws {
        return
    }
    
    func updateKey(_ key: Data, with identifier: String) throws {
        return
    }
    
    func fetchKey(for identifier: String) throws -> Data {
        let keypair = getKeypair()
        let privateKeyData = (keypair?.privateKey().rawData())!
        return privateKeyData
    }
    
    func checkKey(for identifier: String) throws -> Bool {
        return true
    }
    
    func deleteKey(for identifier: String) throws {
        return
    }
    
    func getKeypair() -> IRCryptoKeypairProtocol? {
        let mnemonic = "quote grocery buzz staff merit patch outdoor depth eight raw rubber once"
        
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
}

