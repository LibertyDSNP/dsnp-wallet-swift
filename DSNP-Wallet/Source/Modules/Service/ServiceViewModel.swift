//
//  ServiceViewModel.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 3/1/23.
//

import RobinHood
import SubstrateSdk

protocol ServiceViewModelProtocol {
    func execute(extrinsic: ExtrinsicCalls,
                 from user: User,
                 subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                 notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure)
    func getMsa(from user: User, completion: @escaping (UInt32)->())
    
    func process(from user: User, blockhash: Data, completion: @escaping TransactionSubscriptionCompletion)
}

class ServiceViewModel: ServiceViewModelProtocol {
    var chainRegistry: ChainRegistryProtocol = ChainRegistryFacade.sharedRegistry
    var extrinsicManager: ExtrinsicManager
    
    //Storage Query
    var storageRequestFactory: StorageRequestFactoryProtocol
    var msaSubscription: MsaSubscription?
    
    //Extrinsic Event Subscription
    var extrinsicSubscriptionId: UInt16?
    var txSubscriptionManager: TransactionSubscriptionManagerProtocol?
    
    init() {
        //TODO: Overlapping logic between service coordinator and exMan and msaSubscription
        let serviceCoordinator = ServiceCoordinator.createDefault()
        serviceCoordinator.setup()
        
        self.extrinsicManager = ExtrinsicManager(chainRegistry: chainRegistry)
        
        let assetsOperationQueue = OperationManagerFacade.assetsQueue
        let assetsOperationManager = OperationManager(operationQueue: assetsOperationQueue)
        storageRequestFactory = StorageRequestFactory(
            remoteFactory: StorageKeyFactory(),
            operationManager: assetsOperationManager
        )
        self.msaSubscription = MsaSubscription(chainRegistry: chainRegistry,
                                               storageRequestFactory: storageRequestFactory)
    }
    
    //MARK: Extrinsic
    func execute(extrinsic: ExtrinsicCalls,
                 from user: User,
                 subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                 notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) {
        extrinsicManager.execute(extrinsic: extrinsic,
                                 from: user,
                                 subscriptionIdClosure: subscriptionIdClosure,
                                 notificationClosure: notificationClosure)
    }
    
    //MARK: StorageQuery
    func getMsa(from user: User, completion: @escaping (UInt32)->()) {
        msaSubscription?.getMsaFrom(user: user, completion: completion)
    }
    
    //MARK: Subscription
    func process(from user: User, blockhash: Data, completion: @escaping TransactionSubscriptionCompletion) {
        guard let accountId = user.getAccountId() else { return }
        self.setupExtrinsicEventSubscriptionManager(accountId: accountId)
        
        txSubscriptionManager?.process(blockHash: blockhash, completion: completion)
    }
}

//MARK: Setup
extension ServiceViewModel {
    private func setupExtrinsicEventSubscriptionManager(accountId: AccountId) {
        let repositoryFactory = SubstrateRepositoryFactory()
        
        let chainModel = FrequencyChain.shared.getChainModel()
        
        self.txSubscriptionManager = TransactionSubscriptionManager(chainRegistry: chainRegistry,
                                                                    repositoryFactory: repositoryFactory,
                                                                    accountId: accountId,
                                                                    chainModel: chainModel,
                                                                    storageRequestFactory: storageRequestFactory,
                                                                    eventCenter: EventCenter.shared,
                                                                    logger: Logger.shared)
    }
}

