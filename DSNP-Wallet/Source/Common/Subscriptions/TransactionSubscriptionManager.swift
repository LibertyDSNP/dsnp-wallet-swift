//
//  TransactionSubscriptionManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 4/11/23.
//

import Foundation
import SubstrateSdk
import RobinHood

typealias TransactionSubscriptionCompletion = ([TransactionSubscriptionResult])->()

//EventSubscriptionManager relays event notifications to
//whomever inherits this delegate
protocol TransactionHandlerDelegate: AnyObject {
    func handleTransactions(result: Result<[DataProviderChange<TransactionHistoryItem>], Error>)
}

protocol TransactionSubscriptionManagerProtocol {
    func process(blockHash: Data, completion: @escaping TransactionSubscriptionCompletion)
    func subscribeToTransaction(with txHashString: String) 
}

//MARK: Wrapper class for TransactionSubscription and TransactionProvider
// To handle System->Events following an Extrinsic
class TransactionSubscriptionManager: TransactionSubscriptionManagerProtocol, TransactionLocalStorageSubscriber,
                                      TransactionLocalSubscriptionHandler {
    //MARK: Transaction Subscription
    var transactionSubscription: TransactionSubscription
    weak var handlerDelegate: TransactionHandlerDelegate?
    
    //MARK: TransactionProvider
    var transactionLocalSubscriptionFactory: TransactionLocalSubscriptionFactoryProtocol
    var transactionLocalSubscriptionHandler: TransactionLocalSubscriptionHandler?
    private var transactionProvider: StreamableProvider<TransactionHistoryItem>?
    
    init(transactionLocalSubscriptionFactory: TransactionLocalSubscriptionFactoryProtocol,
         chainRegistry: ChainRegistryProtocol,
         repositoryFactory: SubstrateRepositoryFactoryProtocol,
         accountId: AccountId,
         chainModel: ChainModel,
         storageRequestFactory: StorageRequestFactoryProtocol,
         eventCenter: EventCenterProtocol,
         handlerDelegate: TransactionHandlerDelegate?,
         logger: LoggerProtocol
    ) {
        self.transactionLocalSubscriptionFactory = transactionLocalSubscriptionFactory
        self.handlerDelegate = handlerDelegate
        
        let address = try! accountId.toAddress(using: chainModel.chainFormat)
        let txStorage = repositoryFactory.createChainAddressTxRepository(
            for: address,
            chainId: chainModel.chainId
        )
        
        transactionSubscription = TransactionSubscription(chainRegistry: chainRegistry,
                                                          accountId: accountId,
                                                          chainModel: chainModel,
                                                          txStorage: txStorage,
                                                          storageRequestFactory: storageRequestFactory,
                                                          operationQueue: .main,
                                                          eventCenter: eventCenter,
                                                          logger: logger)
    }
    
    //Record events from this blockhash to storage, referenced by txHash below
    func process(blockHash: Data, completion: @escaping TransactionSubscriptionCompletion) {
        transactionSubscription.process(blockHash: blockHash, completion: completion)
    }
    
    //MARK: Unused Subscription Logic (Start)
    //TODO: The logic below works when provided the right txhash. However, providing txHash requires
    //modifying the extrinsicService.submitAndWatch logic (like .submit() does), which I'd like to avoid
    //for now, so going to trickle the results of transactionHistoryItems as completion in TransSub.process() until we need to implement history or more complex transaction result cases
    func subscribeToTransaction(with txHashString: String) {
        let source: TransactionHistoryItemSource = .substrate
        let identifier = TransactionHistoryItem.createIdentifier(from: txHashString,
                                                                 source: source)
        self.transactionProvider = self.subscribeToTransaction(for: identifier,
                                                               chainId: FrequencyChain.shared.id)
    }
    
    func handleTransactions(result: Result<[DataProviderChange<TransactionHistoryItem>], Error>) {
        handlerDelegate?.handleTransactions(result: result)
    }
    //MARK: Unused Subscription Logic (End)
}
