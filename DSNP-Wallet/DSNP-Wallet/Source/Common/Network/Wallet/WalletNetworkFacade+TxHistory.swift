import Foundation
import RobinHood
import CommonWallet
import IrohaCrypto

extension WalletNetworkFacade {
    func createEmptyHistoryResponseOperation() -> CompoundOperationWrapper<AssetTransactionPageData?> {
        let pageData = AssetTransactionPageData(
            transactions: [],
            context: nil
        )

        let operation = BaseOperation<AssetTransactionPageData?>()
        operation.result = .success(pageData)
        return CompoundOperationWrapper(targetOperation: operation)
    }

    func createLocalFetchWrapper(
        for filter: WalletHistoryFilter,
        txStorage: AnyDataProviderRepository<TransactionHistoryItem>
    ) -> CompoundOperationWrapper<[TransactionHistoryItem]> {
        let fetchOperation = txStorage.fetchAllOperation(with: RepositoryFetchOptions())

        let filterOperation = ClosureOperation<[TransactionHistoryItem]> {
            let items = try fetchOperation.extractNoCancellableResultData()

            return items.filter { item in
                if item.callPath.isTransfer, !filter.contains(.transfers) {
                    return false
                } else if !item.callPath.isTransfer, !filter.contains(.extrinsics) {
                    return false
                } else {
                    return true
                }
            }
        }

        filterOperation.addDependency(fetchOperation)

        return CompoundOperationWrapper(targetOperation: filterOperation, dependencies: [fetchOperation])
    }
}
