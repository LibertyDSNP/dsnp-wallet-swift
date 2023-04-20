//
//  MsaSubscription.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 4/11/23.
//

import Foundation
import SubstrateSdk
import RobinHood

class MsaSubscription {
    let chainRegistry: ChainRegistryProtocol
    let storageRequestFactory: StorageRequestFactoryProtocol
    
    init(chainRegistry: ChainRegistryProtocol,
         storageRequestFactory: StorageRequestFactoryProtocol) {
        self.chainRegistry = chainRegistry
        self.storageRequestFactory = storageRequestFactory
    }
        
    func getMsaFrom(user: User, completion: @escaping (UInt32)->()) {
        let chainId = FrequencyChain.shared.id
        guard let publicKey = user.publicKey?.rawData(),
              let connection = chainRegistry.getConnection(for: chainId),
              let runtimeService = chainRegistry.getRuntimeProvider(for: chainId) else { return }
        
        let factory = GetMsaFromPublicKeyOperationFactory(connection: connection,
                                                          runtimeService: runtimeService,
                                                          storageRequestFactory: storageRequestFactory)
        
        let operationManager = OperationManagerFacade.sharedManager
        let operationWrapper = factory.fetchGetMsaOperationWrapper(from: publicKey)
        
        operationWrapper.targetOperation.completionBlock = {
            do {
                let msa = try operationWrapper.targetOperation.extractNoCancellableResultData()
                completion(msa)
            } catch {
                print("\(error)")
            }
        }
        
        operationManager.enqueue(operations: operationWrapper.allOperations, in: .transient)
    }
}

class GetMsaFromPublicKeyOperationFactory {
    let connection: JSONRPCEngine
    let runtimeService: RuntimeCodingServiceProtocol
    let storageRequestFactory: StorageRequestFactoryProtocol

    init(connection: JSONRPCEngine,
         runtimeService: RuntimeCodingServiceProtocol,
         storageRequestFactory: StorageRequestFactoryProtocol) {
        self.connection = connection
        self.runtimeService = runtimeService
        self.storageRequestFactory = storageRequestFactory
    }
    
    func fetchGetMsaOperationWrapper(from publicKey: Data) -> CompoundOperationWrapper<UInt32> {
        let keyFactory = StorageKeyFactory()
        let codingFactoryOperation = runtimeService.fetchCoderFactoryOperation()

        let wrapper: CompoundOperationWrapper<[StorageResponse<StringScaleMapper<UInt32>>]> =
            storageRequestFactory.queryItems(
                engine: connection,
                keys: { [try keyFactory.msa(from: publicKey)] },
                factory: { try codingFactoryOperation.extractNoCancellableResultData() },
                storagePath: .publicKeyToMsa
            )

        let dependencies = wrapper.allOperations
        dependencies.forEach { $0.addDependency(codingFactoryOperation) }

        let mergeOperation = ClosureOperation<UInt32> {
            guard
                let msa = try wrapper.targetOperation.extractNoCancellableResultData()
                .first?.value?.value
            else {
                throw SubscriptionError.unknown
            }

            return msa
        }

        dependencies.forEach { mergeOperation.addDependency($0) }

        return CompoundOperationWrapper(
            targetOperation: mergeOperation,
            dependencies: dependencies + [codingFactoryOperation]
        )
    }
}
