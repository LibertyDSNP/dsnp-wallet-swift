import Foundation
import RobinHood

protocol SubstrateRepositoryFactoryProtocol {
    func createChainStorageItemRepository() -> AnyDataProviderRepository<ChainStorageItem>
    func createChainStorageItemRepository(filter: NSPredicate) -> AnyDataProviderRepository<ChainStorageItem>

    func createAssetBalanceRepository() -> AnyDataProviderRepository<AssetBalance>
    func createAssetBalanceRepository(for chainAssetIds: Set<ChainAssetId>) -> AnyDataProviderRepository<AssetBalance>
    func createStashItemRepository() -> AnyDataProviderRepository<StashItem>
    func createSingleValueRepository() -> AnyDataProviderRepository<SingleValueProviderObject>
    func createChainRepository() -> AnyDataProviderRepository<ChainModel>

    func createTxRepository() -> AnyDataProviderRepository<TransactionHistoryItem>

    func createChainAddressTxRepository(
        for address: AccountAddress,
        chainId: ChainModel.Id
    ) -> AnyDataProviderRepository<TransactionHistoryItem>

    func createCustomAssetTxRepository(
        for address: AccountAddress,
        chainId: ChainModel.Id,
        assetId: UInt32,
        source: TransactionHistoryItemSource?
    ) -> AnyDataProviderRepository<TransactionHistoryItem>

    func createUtilityAssetTxRepository(
        for address: AccountAddress,
        chainId: ChainModel.Id,
        assetId: UInt32,
        source: TransactionHistoryItemSource?
    ) -> AnyDataProviderRepository<TransactionHistoryItem>
}

final class SubstrateRepositoryFactory: SubstrateRepositoryFactoryProtocol {
    let storageFacade: StorageFacadeProtocol

    init(storageFacade: StorageFacadeProtocol = SubstrateDataStorageFacade.shared) {
        self.storageFacade = storageFacade
    }

    func createChainStorageItemRepository() -> AnyDataProviderRepository<ChainStorageItem> {
        let repository: CoreDataRepository<ChainStorageItem, CDChainStorageItem> =
            storageFacade.createRepository()

        return AnyDataProviderRepository(repository)
    }

    func createChainStorageItemRepository(
        filter: NSPredicate
    ) -> AnyDataProviderRepository<ChainStorageItem> {
        let repository: CoreDataRepository<ChainStorageItem, CDChainStorageItem> =
            storageFacade.createRepository(filter: filter)

        return AnyDataProviderRepository(repository)
    }

    func createStashItemRepository() -> AnyDataProviderRepository<StashItem> {
        let mapper: CodableCoreDataMapper<StashItem, CDStashItem> =
            CodableCoreDataMapper(entityIdentifierFieldName: #keyPath(CDStashItem.stash))

        let repository: CoreDataRepository<StashItem, CDStashItem> =
            storageFacade.createRepository(
                filter: nil,
                sortDescriptors: [],
                mapper: AnyCoreDataMapper(mapper)
            )

        return AnyDataProviderRepository(repository)
    }

    func createSingleValueRepository() -> AnyDataProviderRepository<SingleValueProviderObject> {
        let repository: CoreDataRepository<SingleValueProviderObject, CDSingleValue> =
            storageFacade.createRepository()

        return AnyDataProviderRepository(repository)
    }

    func createChainRepository() -> AnyDataProviderRepository<ChainModel> {
        let repository: CoreDataRepository<ChainModel, CDChain> =
            storageFacade.createRepository(
                filter: nil,
                sortDescriptors: [NSSortDescriptor.chainsByAddressPrefix],
                mapper: AnyCoreDataMapper(ChainModelMapper())
            )

        return AnyDataProviderRepository(repository)
    }

    func createTxRepository() -> AnyDataProviderRepository<TransactionHistoryItem> {
        let repository: CoreDataRepository<TransactionHistoryItem, CDTransactionItem> =
            storageFacade.createRepository()
        return AnyDataProviderRepository(repository)
    }

    func createCustomAssetTxRepository(
        for address: AccountAddress,
        chainId: ChainModel.Id,
        assetId: UInt32,
        source: TransactionHistoryItemSource?
    ) -> AnyDataProviderRepository<TransactionHistoryItem> {
        let txFilter = NSPredicate.filterTransactionsBy(
            address: address,
            chainId: chainId,
            assetId: assetId,
            source: source
        )

        return createTxRepository(for: txFilter)
    }

    func createChainAddressTxRepository(
        for address: AccountAddress,
        chainId: ChainModel.Id
    ) -> AnyDataProviderRepository<TransactionHistoryItem> {
        let txFilter = NSPredicate.filterTransactionsBy(
            address: address,
            chainId: chainId
        )

        return createTxRepository(for: txFilter)
    }

    func createUtilityAssetTxRepository(
        for address: AccountAddress,
        chainId: ChainModel.Id,
        assetId: UInt32,
        source: TransactionHistoryItemSource?
    ) -> AnyDataProviderRepository<TransactionHistoryItem> {
        let txFilter = NSPredicate.filterUtilityAssetTransactionsBy(
            address: address,
            chainId: chainId,
            utilityAssetId: assetId,
            source: source
        )

        return createTxRepository(for: txFilter)
    }

    func createAssetBalanceRepository() -> AnyDataProviderRepository<AssetBalance> {
        let mapper = AssetBalanceMapper()
        let repository = storageFacade.createRepository(mapper: AnyCoreDataMapper(mapper))
        return AnyDataProviderRepository(repository)
    }

    func createAssetBalanceRepository(
        for chainAssetIds: Set<ChainAssetId>
    ) -> AnyDataProviderRepository<AssetBalance> {
        let mapper = AssetBalanceMapper()
        let filter = NSPredicate.assetBalance(chainAssetIds: chainAssetIds)

        let repository = storageFacade.createRepository(
            filter: filter,
            sortDescriptors: [],
            mapper: AnyCoreDataMapper(mapper)
        )

        return AnyDataProviderRepository(repository)
    }

    private func createTxRepository(
        for filter: NSPredicate
    ) -> AnyDataProviderRepository<TransactionHistoryItem> {
        let sortDescriptor = NSSortDescriptor(
            key: #keyPath(CDTransactionItem.timestamp),
            ascending: false
        )
        let txStorage: CoreDataRepository<TransactionHistoryItem, CDTransactionItem> =
            storageFacade.createRepository(filter: filter, sortDescriptors: [sortDescriptor])
        return AnyDataProviderRepository(txStorage)
    }
}
