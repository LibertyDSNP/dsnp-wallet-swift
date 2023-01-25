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
    //MARK: Constants
    let chainId = "496e2f8a93bf4576317f998d01480f9068014b368856ec088a63e57071cd1d49"
    
    let aliceAddress = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"
    let bobAddress = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty"
    let thirdAddress = "5FxxBckLfzKYA42vsj7tihMMrUY7tF7mGk5Asez7JfRPsAsw"
    let secondTestAddress = "5FF2rYk6NCBpHAYjjE2RTQutVHK5BTGoBtcdvU3SQGxz4sZx"
    
    var aliceAccountId: Data!
    var bobAccountId: Data!
    var thirdAccountId: Data!
    var secondTestAccountId: Data!
    
    let frequencyPrefixValue: UInt16 = 42
    
    let seedPhrase = "quote grocery buzz staff merit patch outdoor depth eight raw rubber once" //"third" account
    
    //MARK: Variables
    var extrinsicService: ExtrinsicService?
    let callFactory: SubstrateCallFactory = SubstrateCallFactory()
    var signer: SigningWrapper?
    
    enum TestError: Error {
        case badSetup
    }
    
    override func setUpWithError() throws {
        aliceAccountId = try aliceAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        bobAccountId = try bobAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        thirdAccountId = try thirdAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        secondTestAccountId = try secondTestAddress.toAccountId(using: .substrate(frequencyPrefixValue))
        
        let keyManager = RyanKeyManager()
        let keypair = keyManager.getKeypair()
        
        guard let senderId = thirdAccountId,
              let publicKey = keypair?.publicKey().rawData() else { throw TestError.badSetup }
        
        setExtrinsicService(with: senderId)
        setSigner(with: senderId, publicKey: publicKey)
    }

    override func tearDownWithError() throws {
        
    }
    
    func testCreateMSA() throws {
        let closure: ExtrinsicBuilderClosure = { builder in
            let call = self.callFactory.createMsa()
            _ = try builder.adding(call: call)
            return builder
        }
        
        guard let signer = signer else { throw TestError.badSetup }
        
        let feeExpectation = XCTestExpectation()
        extrinsicService?.submit(closure,
                                signer: signer,
                                runningIn: .main) { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                XCTFail("\(error)")
            }
            feeExpectation.fulfill()
        }
        
        wait(for: [feeExpectation], timeout: 10)
    }
    
//    func testAddPublicKeyToMsa() throws {
//        let closure: ExtrinsicBuilderClosure = { builder in
//            let call = self.callFactory.addPublicKeyToMsa()
//            _ = try builder.adding(call: call)
//            return builder
//        }
//        
//        guard let signer = signer else { throw TestError.badSetup }
//        
//        let feeExpectation = XCTestExpectation()
//        extrinsicService?.submit(closure,
//                                signer: signer,
//                                runningIn: .main) { result in
//            switch result {
//            case .success(let result):
//                print(result)
//            case .failure(let error):
//                XCTFail("\(error)")
//            }
//            
//            feeExpectation.fulfill()
//        }
//        
//        wait(for: [feeExpectation], timeout: 10)
//    }
    
    func testTransfer() throws {
        let receiverId: Data = secondTestAccountId
        
        let closure: ExtrinsicBuilderClosure = { builder in
            let call = self.callFactory.nativeTransfer(to: receiverId, amount: 100000000)
            _ = try builder.adding(call: call)
            return builder
        }
        
        guard let signer = signer else { throw TestError.badSetup }
        
        let feeExpectation = XCTestExpectation()
        extrinsicService?.submit(closure,
                                signer: signer,
                                runningIn: .main) { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                XCTFail("\(error)")
            }
            
            feeExpectation.fulfill()
        }
        
        wait(for: [feeExpectation], timeout: 10)
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

//MARK: Helper Funcs for Setup
extension ExtrinsicTest {
    private func setExtrinsicService(with senderId: Data) {
        let chainRegistry = ChainRegistryFactory.createDefaultRegistry()
        
        let serviceCoordinator = ServiceCoordinator.createDefault()
        serviceCoordinator.setup()
        
        guard let chain = chainRegistry.getChain(for: chainId),
              let connection = chainRegistry.getConnection(for: chainId),
              let runtimeService = chainRegistry.getRuntimeProvider(for: chainId) else {
            XCTFail("Couldn't setup extrinsic service or public key")
            return
        }
        let operationManager = OperationManager(operationQueue: .main)
        
        extrinsicService = ExtrinsicService(accountId: senderId,
                                chain: chain,
                                cryptoType: .sr25519,
                                runtimeRegistry: runtimeService,
                                engine: connection,
                                operationManager: operationManager)
    }
    
    private func setSigner(with senderId: Data, publicKey: Data) {
        let keystore = RyanKeyManager()
        let accountResponse = getChainAccountResponse(senderId: senderId, publicKey: publicKey)
        signer = SigningWrapper(keystore: keystore,
                                    metaId: "",
                                    accountResponse: accountResponse)
    }
    
    private func getChainAccountResponse(senderId: Data, publicKey: Data) -> ChainAccountResponse {
        return ChainAccountResponse(chainId: chainId,
                                    accountId: senderId,
                                    publicKey: publicKey,
                                    name: "Ryan",
                                    cryptoType: .sr25519,
                                    addressPrefix: frequencyPrefixValue,
                                    isEthereumBased: false,
                                    isChainAccount: false)
    }
}

