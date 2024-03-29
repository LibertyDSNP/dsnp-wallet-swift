import Foundation
import SubstrateSdk

protocol WalletRemoteSubscriptionWrapperProtocol {
    func subscribe(
        using assetStorageInfo: AssetStorageInfo,
        accountId: AccountId,
        chainAsset: ChainAsset,
        completion: RemoteSubscriptionClosure?
    ) -> UUID?

    func unsubscribe(
        from subscriptionId: UUID,
        assetStorageInfo: AssetStorageInfo,
        accountId: AccountId,
        chainAssetId: ChainAssetId,
        completion: RemoteSubscriptionClosure?
    )
}

final class WalletRemoteSubscriptionWrapper {
    let chainRegistry: ChainRegistryProtocol
    let remoteSubscriptionService: WalletRemoteSubscriptionServiceProtocol
    let repositoryFactory: SubstrateRepositoryFactoryProtocol
    let eventCenter: EventCenterProtocol
    let operationQueue: OperationQueue
    let logger: LoggerProtocol

    init(
        remoteSubscriptionService: WalletRemoteSubscriptionServiceProtocol,
        chainRegistry: ChainRegistryProtocol,
        repositoryFactory: SubstrateRepositoryFactoryProtocol,
        eventCenter: EventCenterProtocol,
        operationQueue: OperationQueue,
        logger: LoggerProtocol
    ) {
        self.remoteSubscriptionService = remoteSubscriptionService
        self.chainRegistry = chainRegistry
        self.repositoryFactory = repositoryFactory
        self.eventCenter = eventCenter
        self.operationQueue = operationQueue
        self.logger = logger
    }

    func subscribeAssets(
        using extras: StatemineAssetExtras,
        accountId: AccountId,
        chainAssetId: ChainAssetId,
        completion: RemoteSubscriptionClosure?
    ) -> UUID? {
        let assetRepository = repositoryFactory.createAssetBalanceRepository()
        let chainItemRepository = repositoryFactory.createChainStorageItemRepository()

        let balanceUpdater = AssetsBalanceUpdater(
            chainAssetId: chainAssetId,
            accountId: accountId,
            extras: extras,
            chainRegistry: chainRegistry,
            assetRepository: assetRepository,
            transactionSubscription: nil,
            eventCenter: eventCenter,
            operationQueue: operationQueue,
            logger: logger
        )

        return remoteSubscriptionService.attachToAsset(
            of: accountId,
            extras: extras,
            chainId: chainAssetId.chainId,
            queue: .main,
            closure: completion,
            assetBalanceUpdater: balanceUpdater,
            transactionSubscription: nil
        )
    }

    func subscribeOrml(
        using currencyId: Data,
        accountId: AccountId,
        chainAssetId: ChainAssetId,
        completion: RemoteSubscriptionClosure?
    ) -> UUID? {
        return nil
    }

    func subscribeNative(
        for accountId: AccountId,
        chainAssetId: ChainAssetId,
        chainFormat: ChainFormat,
        completion: RemoteSubscriptionClosure?
    ) -> UUID? {
//        let assetRepository = repositoryFactory.createAssetBalanceRepository()
//
//        let subscriptionHandlingFactory = AccountInfoSubscriptionHandlingFactory(
//            chainAssetId: chainAssetId,
//            accountId: accountId,
//            chainRegistry: chainRegistry,
//            assetRepository: assetRepository,
//            transactionSubscription: nil,
//            eventCenter: eventCenter
//        )
//
//        return remoteSubscriptionService.attachToAccountInfo(
//            of: accountId,
//            chainId: chainAssetId.chainId,
//            chainFormat: chainFormat,
//            queue: .main,
//            closure: completion,
//            subscriptionHandlingFactory: subscriptionHandlingFactory
//        )
        return nil
    }
}

extension WalletRemoteSubscriptionWrapper: WalletRemoteSubscriptionWrapperProtocol {
    func subscribe(
        using assetStorageInfo: AssetStorageInfo,
        accountId: AccountId,
        chainAsset: ChainAsset,
        completion: RemoteSubscriptionClosure?
    ) -> UUID? {
        switch assetStorageInfo {
        case .native:
            return subscribeNative(
                for: accountId,
                chainAssetId: chainAsset.chainAssetId,
                chainFormat: chainAsset.chain.chainFormat,
                completion: completion
            )
        case let .statemine(extras):
            return subscribeAssets(
                using: extras,
                accountId: accountId,
                chainAssetId: chainAsset.chainAssetId,
                completion: completion
            )
        case let .orml(_, currencyData, _, _):
            return subscribeOrml(
                using: currencyData,
                accountId: accountId,
                chainAssetId: chainAsset.chainAssetId,
                completion: completion
            )
        }
    }

    func unsubscribe(
        from subscriptionId: UUID,
        assetStorageInfo: AssetStorageInfo,
        accountId: AccountId,
        chainAssetId: ChainAssetId,
        completion: RemoteSubscriptionClosure?
    ) {
        switch assetStorageInfo {
        case .native:
            remoteSubscriptionService.detachFromAccountInfo(
                for: subscriptionId,
                accountId: accountId,
                chainId: chainAssetId.chainId,
                queue: .main,
                closure: completion
            )
        case let .statemine(extras):
            return
//            remoteSubscriptionService.detachFromAsset(
//                for: subscriptionId,
//                accountId: accountId,
//                assetId: extras.assetId,
//                chainId: chainAssetId.chainId,
//                queue: .main,
//                closure: completion
//            )
        case let .orml(_, currencyData, _, _):
            remoteSubscriptionService.detachFromOrmlToken(
                for: subscriptionId,
                accountId: accountId,
                currencyId: currencyData,
                chainId: chainAssetId.chainId,
                queue: .main,
                closure: completion
            )
        }
    }
}
