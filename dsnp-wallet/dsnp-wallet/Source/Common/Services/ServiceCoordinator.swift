import Foundation
import SoraKeystore
import SoraFoundation
import SubstrateSdk
import RobinHood

protocol ServiceCoordinatorProtocol: ApplicationServiceProtocol {
    func updateOnAccountChange()
}

final class ServiceCoordinator {
    let walletSettings: SelectedWalletSettings?
    let accountInfoService: AccountInfoUpdatingServiceProtocol
    let assetsService: AssetsUpdatingServiceProtocol

    init(
        walletSettings: SelectedWalletSettings?,
        accountInfoService: AccountInfoUpdatingServiceProtocol,
        assetsService: AssetsUpdatingServiceProtocol
    ) {
        self.walletSettings = walletSettings
        self.accountInfoService = accountInfoService
        self.assetsService = assetsService
    }

    private func setup(chainRegistry: ChainRegistryProtocol) {
        chainRegistry.syncUp()
    }
}

extension ServiceCoordinator: ServiceCoordinatorProtocol {
    func updateOnAccountChange() {
//        if let seletedMetaAccount = walletSettings.value {
//            accountInfoService.update(selectedMetaAccount: seletedMetaAccount)
//            assetsService.update(selectedMetaAccount: seletedMetaAccount)
//        }
    }

    func setup() {
        let chainRegistry = ChainRegistryFacade.sharedRegistry
        setup(chainRegistry: chainRegistry)

        accountInfoService.setup()
//        assetsService.setup()
    }

    func throttle() {
        accountInfoService.throttle()
//        assetsService.throttle()
    }
}

extension ServiceCoordinator {
    static func createDefault() -> ServiceCoordinatorProtocol {
        let chainRegistry = ChainRegistryFacade.sharedRegistry
        let repository = SubstrateRepositoryFactory().createChainStorageItemRepository()
        let logger = Logger.shared

        let assetsOperationQueue = OperationManagerFacade.assetsQueue
        let assetsOperationManager = OperationManager(operationQueue: assetsOperationQueue)

        let walletSettings = SelectedWalletSettings.shared
        let substrateStorageFacade = SubstrateDataStorageFacade.shared

        let walletRemoteSubscription = WalletRemoteSubscriptionService(
            chainRegistry: chainRegistry,
            repository: repository,
            operationManager: assetsOperationManager,
            logger: logger
        )

        let storageRequestFactory = StorageRequestFactory(
            remoteFactory: StorageKeyFactory(),
            operationManager: assetsOperationManager
        )

        let accountInfoService = AccountInfoUpdatingService(
            selectedAccount: nil,
            chainRegistry: chainRegistry,
            remoteSubscriptionService: walletRemoteSubscription,
            storageFacade: substrateStorageFacade,
            storageRequestFactory: storageRequestFactory,
            eventCenter: EventCenter.shared,
            operationQueue: assetsOperationQueue,
            logger: logger
        )

        let assetsService = AssetsUpdatingService(
            selectedAccount: nil,
            chainRegistry: chainRegistry,
            remoteSubscriptionService: walletRemoteSubscription,
            storageFacade: substrateStorageFacade,
            storageRequestFactory: storageRequestFactory,
            eventCenter: EventCenter.shared,
            operationQueue: assetsOperationQueue,
            logger: logger
        )

        return ServiceCoordinator(
            walletSettings: walletSettings,
            accountInfoService: accountInfoService,
            assetsService: assetsService
        )
    }
}
