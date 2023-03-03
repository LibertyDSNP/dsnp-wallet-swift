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
    func execute(extrinsic: ExtrinsicCalls, from user: User, completion: @escaping ExtrinsicSubmitClosure)
    func getMsa(from user: User, completion: @escaping (UInt32)->())
}

class ServiceViewModel: ServiceViewModelProtocol {
    var chainRegistry: ChainRegistryProtocol = ChainRegistryFacade.sharedRegistry
    var extrinsicManager: ExtrinsicManager
    var msaSubscription: MsaSubscription
    
    init() {
        //TODO: Overlapping logic between service coordinator and exMan and msaSubscription
        let serviceCoordinator = ServiceCoordinator.createDefault()
        serviceCoordinator.setup()
        
        self.extrinsicManager = ExtrinsicManager(chainRegistry: chainRegistry)
        
        let assetsOperationQueue = OperationManagerFacade.assetsQueue
        let assetsOperationManager = OperationManager(operationQueue: assetsOperationQueue)
        let storageRequestFactory = StorageRequestFactory(
            remoteFactory: StorageKeyFactory(),
            operationManager: assetsOperationManager
        )
        self.msaSubscription = MsaSubscription(chainRegistry: chainRegistry,
                                               storageRequestFactory: storageRequestFactory)
    }
    
    func execute(extrinsic: ExtrinsicCalls, from user: User, completion: @escaping ExtrinsicSubmitClosure) {
        extrinsicManager.execute(extrinsic: extrinsic,
                                 from: user,
                                 completion: completion)
    }
    
    func getMsa(from user: User, completion: @escaping (UInt32)->()) {
        msaSubscription.getMsaFrom(user: user, completion: completion)
    }
}

