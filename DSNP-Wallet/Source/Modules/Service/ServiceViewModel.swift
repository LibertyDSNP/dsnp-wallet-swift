//
//  ServiceViewModel.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 3/1/23.
//

import RobinHood
import SubstrateSdk

//MARK: First stab at relaying the serviceCoordinator logic throughout the app for testing purposes
protocol ServiceViewModelProtocol {
    func execute(extrinsic: ExtrinsicCalls,
                 from user: User,
                 subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                 notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure)
    func getMsa(from user: User, completion: @escaping (UInt32)->())
    func process(from user: User, blockhash: Data)
}

class ServiceViewModel: ServiceViewModelProtocol {
    var chainRegistry: ChainRegistryProtocol = ChainRegistryFacade.sharedRegistry
    var extrinsicManager: ExtrinsicManager
    var storageRequestFactory: StorageRequestFactoryProtocol
    var msaSubscription: MsaSubscription?
    var eventSubscriptionManager: EventSubscriptionManager?

    
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
    
    func execute(extrinsic: ExtrinsicCalls,
                 from user: User,
                 subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                 notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) {
        extrinsicManager.execute(extrinsic: extrinsic,
                                 from: user,
                                 subscriptionIdClosure: subscriptionIdClosure,
                                 notificationClosure: notificationClosure)
    }
    
    func getMsa(from user: User, completion: @escaping (UInt32)->()) {
        msaSubscription?.getMsaFrom(user: user, completion: completion)
    }
    
    func process(from user: User, blockhash: Data) {
        guard let accountId = user.getAccountId() else { return }
        self.setupExtrinsicEventSubscriptionManager(accountId: accountId)
        
        eventSubscriptionManager?.process(blockHash: blockhash)
    }
}

//MARK: Setup
extension ServiceViewModel {
    private func setupExtrinsicEventSubscriptionManager(accountId: AccountId) {
        let repositoryFactory = SubstrateRepositoryFactory()
        
        let chainModel = FrequencyChain.shared.getChainModel()
        
        self.eventSubscriptionManager = EventSubscriptionManager(chainRegistry: chainRegistry,
                                                                 repositoryFactory: repositoryFactory,
                                                                 accountId: accountId,
                                                                 chainModel: chainModel,
                                                                 storageRequestFactory: storageRequestFactory,
                                                                 eventCenter: EventCenter.shared,
                                                                 logger: Logger.shared)
    }
}

