//
//  ExtrinsicManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 2/21/23.
//

import UIKit
import BigInt
import RobinHood
import SubstrateSdk

enum ExtrinsicError: Error {
    case setup
    case signature
    case scaleEncoding
}

enum ExtrinsicCalls {
    case createMsa
    case transfer(amount: BigUInt, toAddress: String)
    case addPublicKeyToMsa(msaId: UInt64, expiration: UInt32, primaryUser: User, secondaryUser: User)
}

protocol ExtrinsicManagerFacadeProtocol {
    var chainRegistry: ChainRegistryProtocol { get }
    var extrinsicService: ExtrinsicService? { get set }
}

class ExtrinsicManager {
    var user: User?
    
    var chainRegistry: ChainRegistryProtocol
    var extrinsicService: ExtrinsicService?
    let callFactory: SubstrateCallFactory = SubstrateCallFactory()
    
    init(chainRegistry: ChainRegistryProtocol) {
        self.chainRegistry = chainRegistry
    }
    
    func execute(extrinsic: ExtrinsicCalls,
                 from user: User,
                 subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                 notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) {
        set(user: user)
        
        switch extrinsic {
        case .createMsa:
            try? createMSA(subscriptionIdClosure: subscriptionIdClosure,
                           notificationClosure: notificationClosure)
        case .transfer(let amount, let toAddress):
            try? transfer(amount: amount,
                          toAddress: toAddress,
                          subscriptionIdClosure: subscriptionIdClosure,
                          notificationClosure: notificationClosure)
        case .addPublicKeyToMsa(let msaId, let expiration, let primaryUser, let secondaryUser):
            try? addPublicKeyToMsa(msaId: msaId,
                                   expiration: expiration,
                                   primaryUser: primaryUser,
                                   secondaryUser: secondaryUser,
                                   subscriptionIdClosure: subscriptionIdClosure,
                                   notificationClosure: notificationClosure)
        }
    }
    
    private func set(user: User) {
        self.user = user
        
        guard let accountId = user.getAccountId() else { return }
        try? setExtrinsicService(with: accountId)
    }
    
    private func setExtrinsicService(with senderId: Data) throws {
        let chainRegistry = ChainRegistryFactory.createDefaultRegistry() //MARK: Does this need to be global
        
        guard let chain = chainRegistry.getChain(for: FrequencyChain.shared.id),
              let connection = chainRegistry.getConnection(for: FrequencyChain.shared.id),
              let runtimeService = chainRegistry.getRuntimeProvider(for: FrequencyChain.shared.id) else {
            throw ExtrinsicError.setup
        }
        let bgQueue = OperationQueue()
        bgQueue.qualityOfService = .background
        let operationManager = OperationManager(operationQueue: bgQueue)
        
        extrinsicService = ExtrinsicService(accountId: senderId,
                                            chain: chain,
                                            cryptoType: .sr25519,
                                            walletType: .watchOnly,
                                            runtimeRegistry: runtimeService,
                                            engine: connection,
                                            operationManager: operationManager)
    }
}

//MARK: Signing Payloads
extension ExtrinsicManager {
    //This function fulfills payload proof requirements of
    // 1) SCALE encoding payloads
    // 2) Appending Bytes tags
    func scaleEncodeWithBytesTags(payload: Data, signedBy signer: SigningWrapper) throws -> MultiSignature? {
        do {
            let payloadWithBytesTag = try self.addBytesTags(to: payload)
            return try self.getProof(with: payloadWithBytesTag, from: signer)
        } catch {
            throw ExtrinsicError.scaleEncoding
        }
    }
    
    private func addBytesTags(to payload: Data) throws -> Data {
        do {
            // Convert payload data to a hex string
            let prefix = "0x3c42797465733e" //<Bytes> in hex
            let payloadHexString = String(payload.toHex().dropFirst(2)) //dropping "b0"
            let postfix = "3c2f42797465733e" //</Bytes> in hex
            let taggedPayloadData = try Data(hexString: prefix + payloadHexString + postfix) // Convert the tagged payload back to data
        
            return taggedPayloadData
        } catch {
            throw ExtrinsicError.scaleEncoding
        }
        
    }
    
    //Takes JSON encoded data, signs it with signer with SR25519 ellipitical curve
    private func getProof(with payloadData: Data, from signer: SigningWrapper) throws -> MultiSignature {
        let rawSig = try signer.sign(payloadData).rawData()
        print("\(rawSig.toHexString())")
        return MultiSignature.sr25519(data: rawSig)
    }
}


