import Foundation
import SubstrateSdk
import RobinHood

protocol WalletRemoteSubscriptionServiceProtocol {
    func detachFromAccountInfo(
        for subscriptionId: UUID,
        accountId: AccountId,
        chainId: ChainModel.Id,
        queue: DispatchQueue?,
        closure: RemoteSubscriptionClosure?
    )

    // swiftlint:disable:next function_parameter_count
    func attachToAsset(
        of accountId: AccountId,
        extras: StatemineAssetExtras,
        chainId: ChainModel.Id,
        queue: DispatchQueue?,
        closure: RemoteSubscriptionClosure?,
        assetBalanceUpdater: AssetsBalanceUpdater,
        transactionSubscription: TransactionSubscription?
    ) -> UUID?

    // swiftlint:disable:next function_parameter_count
    func detachFromAsset(
        for subscriptionId: UUID,
        accountId: AccountId,
        extras: StatemineAssetExtras,
        chainId: ChainModel.Id,
        queue: DispatchQueue?,
        closure: RemoteSubscriptionClosure?
    )

    // swiftlint:disable:next function_parameter_count
//    func attachToOrmlToken(
//        of accountId: AccountId,
//        currencyId: Data,
//        chainId: ChainModel.Id,
//        queue: DispatchQueue?,
//        closure: RemoteSubscriptionClosure?,
//        subscriptionHandlingFactory: OrmlTokenSubscriptionFactoryProtocol?
//    ) -> UUID?

    // swiftlint:disable:next function_parameter_count
    func detachFromOrmlToken(
        for subscriptionId: UUID,
        accountId: AccountId,
        currencyId: Data,
        chainId: ChainModel.Id,
        queue: DispatchQueue?,
        closure: RemoteSubscriptionClosure?
    )
}

class WalletRemoteSubscriptionService: RemoteSubscriptionService, WalletRemoteSubscriptionServiceProtocol {
    func detachFromAccountInfo(
        for subscriptionId: UUID,
        accountId: AccountId,
        chainId: ChainModel.Id,
        queue: DispatchQueue?,
        closure: RemoteSubscriptionClosure?
    ) {
        do {
            let storagePath = StorageCodingPath.account
            let storageKeyFactory = LocalStorageKeyFactory()
            let accountLocalKey = try storageKeyFactory.createFromStoragePath(
                storagePath,
                accountId: accountId,
                chainId: chainId
            )

            let locksStoragePath = StorageCodingPath.balanceLocks
            let locksLocalKey = try storageKeyFactory.createFromStoragePath(
                locksStoragePath,
                encodableElement: accountId,
                chainId: chainId
            )

            let localKey = accountLocalKey + locksLocalKey
            detachFromSubscription(localKey, subscriptionId: subscriptionId, queue: queue, closure: closure)
        } catch {
            callbackClosureIfProvided(closure, queue: queue, result: .failure(error))
        }
    }

    // swiftlint:disable:next function_parameter_count
    func attachToAsset(
        of accountId: AccountId,
        extras: StatemineAssetExtras,
        chainId: ChainModel.Id,
        queue: DispatchQueue?,
        closure: RemoteSubscriptionClosure?,
        assetBalanceUpdater: AssetsBalanceUpdater,
        transactionSubscription _: TransactionSubscription?
    ) -> UUID? {
            return nil
    }

    // swiftlint:disable:next function_parameter_count
    func detachFromAsset(
        for subscriptionId: UUID,
        accountId: AccountId,
        extras: StatemineAssetExtras,
        chainId: ChainModel.Id,
        queue: DispatchQueue?,
        closure: RemoteSubscriptionClosure?
    ) {}

    // swiftlint:disable:next function_parameter_count
//    func attachToOrmlToken(
//        of accountId: AccountId,
//        currencyId: Data,
//        chainId: ChainModel.Id,
//        queue: DispatchQueue?,
//        closure: RemoteSubscriptionClosure?,
//        subscriptionHandlingFactory: OrmlTokenSubscriptionFactoryProtocol?
//    ) -> UUID? {
//            return nil
//    }

    // swiftlint:disable:next function_parameter_count
    func detachFromOrmlToken(
        for subscriptionId: UUID,
        accountId: AccountId,
        currencyId: Data,
        chainId: ChainModel.Id,
        queue: DispatchQueue?,
        closure: RemoteSubscriptionClosure?
    ) {
        do {
            let storageKeyFactory = LocalStorageKeyFactory()
            let accountLocalKey = try storageKeyFactory.createFromStoragePath(
                .ormlTokenAccount,
                encodableElement: accountId + currencyId,
                chainId: chainId
            )
            let locksLocalKey = try storageKeyFactory.createFromStoragePath(
                .ormlTokenLocks,
                encodableElement: accountId + currencyId,
                chainId: chainId
            )
            let localKey = accountLocalKey + locksLocalKey

            detachFromSubscription(localKey, subscriptionId: subscriptionId, queue: queue, closure: closure)

        } catch {
            callbackClosureIfProvided(closure, queue: queue, result: .failure(error))
        }
    }
}
