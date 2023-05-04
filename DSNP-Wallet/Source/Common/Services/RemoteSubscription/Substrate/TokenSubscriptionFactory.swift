import Foundation
import RobinHood
import SubstrateSdk

protocol OrmlTokenSubscriptionFactoryProtocol {
    func createOrmlAccountSubscription(
        remoteStorageKey: Data,
        localStorageKey: String,
        storage: AnyDataProviderRepository<ChainStorageItem>,
        operationManager: OperationManagerProtocol,
        logger: LoggerProtocol
    ) -> StorageChildSubscribing

    func createOrmLocksSubscription(
        remoteStorageKey: Data,
        operationManager: OperationManagerProtocol,
        logger: LoggerProtocol
    ) -> StorageChildSubscribing
}
