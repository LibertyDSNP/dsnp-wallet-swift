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

class ExtrinsicManager {
    var user: User

    var extrinsicService: ExtrinsicService?
    let callFactory: SubstrateCallFactory = SubstrateCallFactory()
    
    init(user: User) {
        self.user = user
        
        guard let accountId = try? user.getAccountId() else { return }
        try? setExtrinsicService(with: accountId)
    }
    
    func execute(extrinsic: ExtrinsicCalls, completion completionClosure: @escaping ExtrinsicSubmitClosure) {
        switch extrinsic {
        case .createMsa:
            try? createMSA(completion: completionClosure)
        case .transfer(let amount, let toAddress):
            try? transfer(amount: amount, toAddress: toAddress, completion: completionClosure)
        case .addPublicKeyToMsa(let primaryUser, let secondaryUser):
            try? addPublicKeyToMsa(primaryUser: primaryUser, secondaryUser: secondaryUser, completion: completionClosure)
        }
    }
    
    private func setExtrinsicService(with senderId: Data) throws {
        let chainRegistry = ChainRegistryFactory.createDefaultRegistry()
        
        let serviceCoordinator = ServiceCoordinator.createDefault()
        serviceCoordinator.setup()
        
        guard let chain = chainRegistry.getChain(for: FrequencyChain.shared.id),
              let connection = chainRegistry.getConnection(for: FrequencyChain.shared.id),
              let runtimeService = chainRegistry.getRuntimeProvider(for: FrequencyChain.shared.id) else {
            throw ExtrinsicError.BadSetup
        }
        let operationManager = OperationManager(operationQueue: .main)
        
        extrinsicService = ExtrinsicService(accountId: senderId,
                                            chain: chain,
                                            cryptoType: .sr25519,
                                            runtimeRegistry: runtimeService,
                                            engine: connection,
                                            operationManager: operationManager)
    }
}
