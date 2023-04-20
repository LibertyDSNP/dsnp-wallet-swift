//
//  EventSubscriptionManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 4/11/23.
//

import Foundation
import SubstrateSdk
import RobinHood

//MARK: Wrapper class for TransactionSubscription and TransactionProvider
// To handle System->Events following an Extrinsic
class EventSubscriptionManager { //TransactionLocalStorageSubscriber {
    //MARK: Transaction Subscription
    var transactionSubscription: TransactionSubscription
    
    //MARK: TransactionProvider
//    var transactionLocalSubscriptionFactory: TransactionLocalSubscriptionFactoryProtocol
//    var transactionLocalSubscriptionHandler: TransactionLocalSubscriptionHandler
    private var transactionProvider: StreamableProvider<TransactionHistoryItem>?
    
    init(chainRegistry: ChainRegistryProtocol,
         repositoryFactory: SubstrateRepositoryFactoryProtocol,
         accountId: AccountId,
         chainModel: ChainModel,
         storageRequestFactory: StorageRequestFactoryProtocol,
         eventCenter: EventCenterProtocol,
         logger: LoggerProtocol
    ) {
        let address = try! accountId.toAddress(using: chainModel.chainFormat)
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
    }
    
    func process(blockHash: Data) {
        //Get the blockhash for the corresponding extrinsic
        //This could come from submitAndWatch apparently
        
        //This will create an operation recording all the eventRecords related to the blockhash
        transactionSubscription.process(blockHash: blockHash)
        
        //This is how we get it
//        transactionProvider = subscribeToTransaction(
//            for: txData.transactionId,
//            chainId: chain.chainId
//        )
    }
}
   
