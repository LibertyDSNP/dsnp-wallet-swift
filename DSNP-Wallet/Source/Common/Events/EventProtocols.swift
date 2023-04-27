import Foundation

protocol EventProtocol {
    func accept(visitor: EventVisitorProtocol)
}

protocol EventCenterProtocol {
    func notify(with event: EventProtocol)
    func add(observer: EventVisitorProtocol, dispatchIn queue: DispatchQueue?)
    func remove(observer: EventVisitorProtocol)
}

extension EventCenterProtocol {
    func add(observer: EventVisitorProtocol) {
        add(observer: observer, dispatchIn: nil)
    }
}

protocol EventVisitorProtocol: AnyObject {
    func processSelectedConnectionChanged(event: SelectedConnectionChanged)
    func processBalanceChanged(event: WalletBalanceChanged)
    func processNewTransaction(event: WalletNewTransactionInserted)
    func processPurchaseCompletion(event: PurchaseCompleted)
    func processTypeRegistryPrepared(event: TypeRegistryPrepared)

    func processChainSyncDidStart(event: ChainSyncDidStart)
    func processChainSyncDidComplete(event: ChainSyncDidComplete)
    func processChainSyncDidFail(event: ChainSyncDidFail)

    func processRuntimeCommonTypesSyncCompleted(event: RuntimeCommonTypesSyncCompleted)
    func processRuntimeChainTypesSyncCompleted(event: RuntimeChainTypesSyncCompleted)
    func processRuntimeChainMetadataSyncCompleted(event: RuntimeMetadataSyncCompleted)

    func processRuntimeCoderReady(event: RuntimeCoderCreated)
    func processRuntimeCoderCreationFailed(event: RuntimeCoderCreationFailed)
}

extension EventVisitorProtocol {
    func processSelectedConnectionChanged(event _: SelectedConnectionChanged) {}
    func processBalanceChanged(event _: WalletBalanceChanged) {}
    func processNewTransaction(event _: WalletNewTransactionInserted) {}
    func processPurchaseCompletion(event _: PurchaseCompleted) {}
    func processTypeRegistryPrepared(event _: TypeRegistryPrepared) {}

    func processChainSyncDidStart(event _: ChainSyncDidStart) {}
    func processChainSyncDidComplete(event _: ChainSyncDidComplete) {}
    func processChainSyncDidFail(event _: ChainSyncDidFail) {}

    func processRuntimeCommonTypesSyncCompleted(event _: RuntimeCommonTypesSyncCompleted) {}
    func processRuntimeChainTypesSyncCompleted(event _: RuntimeChainTypesSyncCompleted) {}
    func processRuntimeChainMetadataSyncCompleted(event _: RuntimeMetadataSyncCompleted) {}

    func processRuntimeCoderReady(event _: RuntimeCoderCreated) {}
    func processRuntimeCoderCreationFailed(event _: RuntimeCoderCreationFailed) {}
}
