import Foundation
import RobinHood

protocol ChainRegistryProtocol: AnyObject {
    var availableChainIds: Set<ChainModel.Id>? { get }

    func getChain(for chainId: ChainModel.Id) -> ChainModel?
    func getConnection(for chainId: ChainModel.Id) -> ChainConnection?
    func getRuntimeProvider(for chainId: ChainModel.Id) -> RuntimeProviderProtocol?

    func chainsSubscribe(
        _ target: AnyObject,
        runningInQueue: DispatchQueue,
        updateClosure: @escaping ([DataProviderChange<ChainModel>]) -> Void
    )

    func chainsUnsubscribe(_ target: AnyObject)

    func subscribeChainState(_ subscriber: ConnectionStateSubscription, chainId: ChainModel.Id)
    func unsubscribeChainState(_ subscriber: ConnectionStateSubscription, chainId: ChainModel.Id)

    func syncUp()
}

final class ChainRegistry {
    let runtimeProviderPool: RuntimeProviderPoolProtocol
    let connectionPool: ConnectionPoolProtocol
    let chainSyncService: ChainSyncServiceProtocol
    let runtimeSyncService: RuntimeSyncServiceProtocol
    let commonTypesSyncService: CommonTypesSyncServiceProtocol
    let chainProvider: StreamableProvider<ChainModel>
    let specVersionSubscriptionFactory: SpecVersionSubscriptionFactoryProtocol
    let processingQueue = DispatchQueue(label: "io.novafoundation.novawallet.chain.registry")
    let logger: LoggerProtocol?

    private(set) var runtimeVersionSubscriptions: [ChainModel.Id: SpecVersionSubscriptionProtocol] = [:]
    private var availableChains = Set<ChainModel>()

    private let mutex = NSLock()

    init(
        runtimeProviderPool: RuntimeProviderPoolProtocol,
        connectionPool: ConnectionPoolProtocol,
        chainSyncService: ChainSyncServiceProtocol,
        runtimeSyncService: RuntimeSyncServiceProtocol,
        commonTypesSyncService: CommonTypesSyncServiceProtocol,
        chainProvider: StreamableProvider<ChainModel>,
        specVersionSubscriptionFactory: SpecVersionSubscriptionFactoryProtocol,
        logger: LoggerProtocol? = nil
    ) {
        self.runtimeProviderPool = runtimeProviderPool
        self.connectionPool = connectionPool
        self.chainSyncService = chainSyncService
        self.runtimeSyncService = runtimeSyncService
        self.commonTypesSyncService = commonTypesSyncService
        self.chainProvider = chainProvider
        self.specVersionSubscriptionFactory = specVersionSubscriptionFactory
        self.logger = logger

        subscribeToChains()
    }

    private func subscribeToChains() {
        // MARK: RYAN

        var newChanges: [DataProviderChange<ChainModel>] = []
        newChanges.append(getFreqChainChange())
        handle(changes: newChanges) // had to manually call handle because have yet to figure out this chainsync/provider logic

        let updateClosure: ([DataProviderChange<ChainModel>]) -> Void = { [weak self] changes in
            self?.handle(changes: changes)
        }

        let failureClosure: (Error) -> Void = { [weak self] error in
            self?.logger?.error("Unexpected error chains listener setup: \(error)")
        }

        let options = StreamableProviderObserverOptions(
            alwaysNotifyOnRefresh: false,
            waitsInProgressSyncOnAdd: false,
            refreshWhenEmpty: false
        )

        chainProvider.addObserver(
            self,
            deliverOn: DispatchQueue.global(qos: .userInitiated),
            executing: updateClosure,
            failing: failureClosure,
            options: options
        )
    }

    private func handle(changes _: [DataProviderChange<ChainModel>]) {
        mutex.lock()

        defer {
            mutex.unlock()
        }

        var newChanges: [DataProviderChange<ChainModel>] = []
        newChanges.append(getFreqChainChange())
//        handle(changes: newChanges) // had to manually call handle because have yet to figure out this chainsync/provider logic

        guard !newChanges.isEmpty else {
            return
        }

        newChanges.forEach { change in
            do {
                switch change {
                case let .insert(newChain):
                    let connection = try connectionPool.setupConnection(for: newChain)
                    _ = runtimeProviderPool.setupRuntimeProvider(for: newChain)

                    runtimeSyncService.register(chain: newChain, with: connection)

                    setupRuntimeVersionSubscription(for: newChain, connection: connection)
                    availableChains.insert(newChain)

                    logger?.debug("Subscribed runtime for: \(newChain.name)")
                case let .update(updatedChain):
                    let connection = try connectionPool.setupConnection(for: updatedChain)
                    _ = runtimeProviderPool.setupRuntimeProvider(for: updatedChain)

                    runtimeSyncService.register(chain: updatedChain, with: connection)

                    if let currentChain = availableChains.firstIndex(where: { $0.chainId == updatedChain.chainId }) {
                        availableChains.remove(at: currentChain)
                    }
                    availableChains.insert(updatedChain)
                case let .delete(chainId):
                    runtimeProviderPool.destroyRuntimeProvider(for: chainId)
                    clearRuntimeSubscription(for: chainId)

                    runtimeSyncService.unregister(chainId: chainId)
                    if let currentChain = availableChains.firstIndex(where: { $0.chainId == chainId }) {
                        availableChains.remove(at: currentChain)
                    }
                }
            } catch {
                logger?.error("Unexpected error on handling chains update: \(error)")
            }
        }
    }

    private func setupRuntimeVersionSubscription(for chain: ChainModel, connection: ChainConnection) {
        let subscription = specVersionSubscriptionFactory.createSubscription(
            for: chain.chainId,
            connection: connection
        )

        subscription.subscribe()

        runtimeVersionSubscriptions[chain.chainId] = subscription
    }

    private func clearRuntimeSubscription(for chainId: ChainModel.Id) {
        if let subscription = runtimeVersionSubscriptions[chainId] {
            subscription.unsubscribe()
        }

        runtimeVersionSubscriptions[chainId] = nil
    }

    private func syncUpServices() {
        chainSyncService.syncUp()
        commonTypesSyncService.syncUp()
    }
}

extension ChainRegistry: ChainRegistryProtocol {
    var availableChainIds: Set<ChainModel.Id>? {
        mutex.lock()

        defer {
            mutex.unlock()
        }

        return Set(runtimeVersionSubscriptions.keys)
    }

    func getChain(for chainId: ChainModel.Id) -> ChainModel? {
        mutex.lock()

        defer {
            mutex.unlock()
        }

        return availableChains.first(where: { $0.chainId == chainId })
    }

    func getConnection(for chainId: ChainModel.Id) -> ChainConnection? {
        mutex.lock()

        defer {
            mutex.unlock()
        }

        return connectionPool.getConnection(for: chainId)
    }

    func getRuntimeProvider(for chainId: ChainModel.Id) -> RuntimeProviderProtocol? {
        mutex.lock()

        defer {
            mutex.unlock()
        }

        return runtimeProviderPool.getRuntimeProvider(for: chainId)
    }

    func chainsSubscribe(
        _ target: AnyObject,
        runningInQueue: DispatchQueue,
        updateClosure: @escaping ([DataProviderChange<ChainModel>]) -> Void
    ) {
        let updateClosure: ([DataProviderChange<ChainModel>]) -> Void = { changes in
            runningInQueue.async {
                updateClosure(changes)
            }
        }

        let failureClosure: (Error) -> Void = { [weak self] error in
            self?.logger?.error("Unexpected error chains listener setup: \(error)")
        }

        let options = StreamableProviderObserverOptions(
            alwaysNotifyOnRefresh: false,
            waitsInProgressSyncOnAdd: false,
            refreshWhenEmpty: false
        )

        chainProvider.addObserver(
            target,
            deliverOn: processingQueue,
            executing: updateClosure,
            failing: failureClosure,
            options: options
        )
    }

    func chainsUnsubscribe(_ target: AnyObject) {
        chainProvider.removeObserver(target)
    }

    func subscribeChainState(_ subscriber: ConnectionStateSubscription, chainId: ChainModel.Id) {
        connectionPool.subscribe(subscriber, chainId: chainId)
    }

    func unsubscribeChainState(_ subscriber: ConnectionStateSubscription, chainId: ChainModel.Id) {
        connectionPool.subscribe(subscriber, chainId: chainId)
    }

    func syncUp() {
        syncUpServices()
    }
}

// MARK: RYAN

extension ChainRegistry {
    func getFreqChainChange() -> DataProviderChange<ChainModel> {
        let typesSettingsUrl = URL(string: "https://raw.githubusercontent.com/nova-wallet/nova-utils/master/chains/v2/types/polkadot.json")!
        let typesSettings = ChainModel.TypesSettings(
            url: typesSettingsUrl,
            overridesCommon: true
        )

        let asset = AssetModel(
            assetId: 0,
            icon: nil,

            name: "Freq", // MARK: RYAN VERIFY

            symbol: "Freq", // MARK: RYAN VERIFY

            precision: 42,
            priceId: nil,
            staking: nil,
            type: nil,
            typeExtras: nil,
            buyProviders: nil
        )

        let localNodeString = "ws://127.0.0.1:9944"
        let localNodeUrl = URL(string: localNodeString)
        let chainNodeModel = ChainNodeModel(
            url: localNodeUrl!,
            name: "Local Node",
            apikey: nil,
            order: 0
        )
        let frequencyChainModel = ChainModel(
            chainId: "496e2f8a93bf4576317f998d01480f9068014b368856ec088a63e57071cd1d49",
            parentId: nil,
            name: "FREQUENCY",
            assets: [asset],
            nodes: [chainNodeModel],
            addressPrefix: 42,
            types: typesSettings,
            icon: URL(string: "www.google.com")!,
            color: nil,
            options: nil,
            externalApi: nil,
            explorers: nil,
            order: 0,
            additional: nil
        )

        let frequencyChange = DataProviderChange<ChainModel>.insert(newItem: frequencyChainModel)
        return frequencyChange
//        var changesWithFrequency: [DataProviderChange<ChainModel>] = [] // changes
    }
}
