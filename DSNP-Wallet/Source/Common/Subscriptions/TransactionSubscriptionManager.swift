//
//  TransactionSubscriptionManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 4/11/23.
//

import Foundation
import SubstrateSdk
import RobinHood

typealias TransactionSubscriptionCompletion = ([TransactionSubscriptionResult])->()

protocol TransactionSubscriptionManagerProtocol {
    func process(blockHash: Data, completion: @escaping TransactionSubscriptionCompletion)
}

// To handle System->Events following an Extrinsic
class TransactionSubscriptionManager: TransactionSubscriptionManagerProtocol {
    var transactionSubscription: TransactionSubscription?
    
    init(chainRegistry: ChainRegistryProtocol,
         repositoryFactory: SubstrateRepositoryFactoryProtocol,
         accountId: AccountId,
         chainModel: ChainModel,
         storageRequestFactory: StorageRequestFactoryProtocol,
         eventCenter: EventCenterProtocol,
         logger: LoggerProtocol
    ) {
        do {
            let address = try accountId.toAddress(using: chainModel.chainFormat)
            
            let txStorage = repositoryFactory.createChainAddressTxRepository(
                for: address,
                chainId: chainModel.chainId
            )
            
            transactionSubscription = TransactionSubscription(chainRegistry: chainRegistry,
                                                              accountId: accountId,
                                                              chainModel: chainModel,
                                                              txStorage: txStorage,
                                                              storageRequestFactory: storageRequestFactory,
                                                              operationQueue: .main,
                                                              eventCenter: eventCenter,
                                                              logger: logger)
        } catch {
            logger.error("Can't instantiate TransactionSubscriptionManager \(error)")
        }
    }
    
    //Record events from this blockhash to storage, referenced by txHash below
    func process(blockHash: Data, completion: @escaping TransactionSubscriptionCompletion) {
        transactionSubscription?.process(blockHash: blockHash, completion: completion)
    }
}
