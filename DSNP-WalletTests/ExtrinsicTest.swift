////
////  ExtrinsicTest.swift
////  DSNP-WalletTests
////
////  Created by Ryan Sheh on 1/18/23.
////
//
//import XCTest
//import SoraKeystore
//import BigInt
//import IrohaCrypto
//
//import RobinHood
//import SubstrateSdk
//import SoraKeystore
//@testable import DSNP_Wallet
//
//import XCTest
//
////MARK: Figure this out
//struct Currency {
//    var units = 100000000
//    var dollars = 1000000
//    var cents = 1000
//    var millicents = 1
//}
//
//class ExtrinsicTest: XCTestCase {
//    let keystore = Keychain()
//    
//    //MARK: Chain Constants
//    let chainId = "496e2f8a93bf4576317f998d01480f9068014b368856ec088a63e57071cd1d49"
//    let frequencyPrefixValue: UInt16 = 42
//    
//    //MARK: Account Constants
//    let aliceAddress = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"
//    let bobAddress = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty"
//
//    let primaryAddress = "5FxxBckLfzKYA42vsj7tihMMrUY7tF7mGk5Asez7JfRPsAsw"
//    let primaryMnemonic = "quote grocery buzz staff merit patch outdoor depth eight raw rubber once"
//    
//    let secondaryAddress = "5DbvWVBoNSjWcQufNQMNJHxWiHGcAdcLX3QEFn6WCd6BBuG7"
//    let secondaryMnemonic = "rifle hub give speak sorry hurt bread shaft ahead whale scatter sleep"
//    
//    //MARK: Variables
//    var extrinsicService: ExtrinsicService?
//    let callFactory: SubstrateCallFactory = SubstrateCallFactory()
//    
//    var primarySigner: SigningWrapper?
//    var secondarySigner: SigningWrapper?
//    
//    var primaryAccountId: Data!
//    var secondaryAccountId: Data!
//    
//    enum TestError: Error {
//        case badSetup
//        case badKeys
//        case badSignature
//    }
//    
//    override func setUpWithError() throws {
//        primaryAccountId = try primaryAddress.toAccountId(using: .substrate(frequencyPrefixValue))
//        secondaryAccountId = try secondaryAddress.toAccountId(using: .substrate(frequencyPrefixValue))
//        
//        try? setAccounts()
//        setExtrinsicService(with: primaryAccountId)
//    }
//    
//    override func tearDownWithError() throws {
//        
//    }
//    
//    func testCreateMSA() throws {
//        let closure: ExtrinsicBuilderClosure = { builder in
//            let call = self.callFactory.createMsa()
//            _ = try builder.adding(call: call)
//            return builder
//        }
//        
//        guard let signer = primarySigner else { throw TestError.badSetup }
//        
//        let feeExpectation = XCTestExpectation()
//        extrinsicService?.submit(closure,
//                                 signer: signer,
//                                 runningIn: .main) { result in
//            switch result {
//            case .success(let result):
//                print(result)
//            case .failure(let error):
//                XCTFail("\(error)")
//            }
//            feeExpectation.fulfill()
//        }
//        
//        wait(for: [feeExpectation], timeout: 10)
//    }
//    
//    func testAddPublicKeyToMsa() throws {
//        let msaOwnerKeypair = primaryKeypair
//        let newOwnerKeypair = secondaryKeypair
//
//        let addKeyPayload = AddKeyPayloadArg(msaId: 1,
//                                             expiration: 5)
//
//        guard let keyPayloadData = try? JSONEncoder().encode(addKeyPayload) else { return }
//
//        guard let msaOwnerPublicKey = msaOwnerKeypair?.publicKey().rawData(),
//              let msaOwnerPrivateKey = msaOwnerKeypair?.privateKey().rawData(),
//              let newOwnerPublicKey = newOwnerKeypair?.publicKey().rawData(),
//              let newOwnerPrivateKey = newOwnerKeypair?.privateKey().rawData() else { throw TestError.badKeys }
//
//        guard let msaOwnerSigner = signer else { throw TestError.badSignature }
//        let newOwnerSigner = setSigner(with: secondaryAccountId, publicKey: newOwnerPublicKey)
//
//        let msaOwnerRawSignature = try msaOwnerSigner.sign(keyPayloadData).rawData()
//        let newOwnerRawSignature = try newOwnerSigner.sign(keyPayloadData).rawData()
//        let msaOwnerSignature = MultiSignature.sr25519(data: msaOwnerRawSignature)
//        let newOwnerSignature = MultiSignature.sr25519(data: newOwnerRawSignature)
//
//        let closure: ExtrinsicBuilderClosure = { builder in
//            let call = self.callFactory.addPublicKeyToMsa(msaOwnerPublicKey: msaOwnerPublicKey,
//                                                          msaOwnerProof: msaOwnerSignature,
//                                                          newKeyOwnerProof: newOwnerSignature,
//                                                          addKeyPayload: addKeyPayload)
//            _ = try builder.adding(call: call)
//            return builder
//        }
//
//        guard let signer = signer else { throw TestError.badSetup }
//
//        let feeExpectation = XCTestExpectation()
//        extrinsicService?.submit(closure,
//                                 signer: signer,
//                                 runningIn: .main) { result in
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
//    
//    func testTransfer() throws {
//        let receiverId: Data = secondaryAccountId
//        
//        let closure: ExtrinsicBuilderClosure = { builder in
//            let call = self.callFactory.nativeTransfer(to: receiverId, amount: 100000000)
//            _ = try builder.adding(call: call)
//            return builder
//        }
//        
//        guard let signer = primarySigner else { throw TestError.badSetup }
//        
//        let feeExpectation = XCTestExpectation()
//        extrinsicService?.submit(closure,
//                                 signer: signer,
//                                 runningIn: .main) { result in
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
//}
//
//
