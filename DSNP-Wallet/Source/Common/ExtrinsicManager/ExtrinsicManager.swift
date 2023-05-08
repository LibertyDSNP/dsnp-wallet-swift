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
    case BadSetup
}

enum ExtrinsicCalls {
    case createMsa
    case transfer(amount: BigUInt, toAddress: String)
    case addPublicKeyToMsa(primaryUser: User, secondaryUser: User)
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
        case .addPublicKeyToMsa(let primaryUser, let secondaryUser):
            try? addPublicKeyToMsa(primaryUser: primaryUser,
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
            throw ExtrinsicError.BadSetup
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


