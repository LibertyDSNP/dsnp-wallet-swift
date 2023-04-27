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
    
    func execute(extrinsic: ExtrinsicCalls, from user: User, completion completionClosure: @escaping ExtrinsicSubmitClosure) {
        set(user: user)
        
        switch extrinsic {
        case .createMsa:
            try? createMSA(completion: completionClosure)
        case .transfer(let amount, let toAddress):
            try? transfer(amount: amount, toAddress: toAddress, completion: completionClosure)
        case .addPublicKeyToMsa(let primaryUser, let secondaryUser):
            try? addPublicKeyToMsa(primaryUser: primaryUser, secondaryUser: secondaryUser, completion: completionClosure)
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

enum SubscriptionError: Error {
    case unknown
}

//TODO: Move to separate class
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
