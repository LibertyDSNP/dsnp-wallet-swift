//
//  TestViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 10/12/22.
//

import Foundation
import UIKit
import RobinHood
import SubstrateSdk
import SoraFoundation
import BigInt

import DSNPWallet

class TestViewController: UIViewController {
    
    let localNodeString = "ws://127.0.0.1:9944"
//    let localNodeString = "wss://kusama-rpc.polkadot.io"
    let chainId = "b0a8d493285c2df73290dfb7e61f870f17b41801197a149ca93654499ea3dafe"
    var chainModel: ChainModel!
    let finalizedBlockHash = "0x19b40c89e73be7a18addb8f2825e7ee00ab38d8ec24073976c1a017e2e918f51"

    private let mutex = NSLock()
    
    override func viewDidLoad() {
        chainModel = ChainModel(chainId: chainId, types: nil)
//        try? getBlockHash(for: 0)
//        getRunTimeVersion()
//        getRunTimeMetadata(at: finalizedBlockHash)
//        test()
//        try? getEstimateFeeForBondExtraCall()
    }
    
//    private func getChainModel() -> ChainModel {
//        let freqChainNodeModel = ChainNodeModel(
//            url: URL(string: "ws://127.0.0.1:9944")!,
//            name: "Frequency",
//            apikey: nil,
//            order: 0
//        )
//
//        return freqChainNodeModel
//    }
    
    private func getConnection() -> ChainConnection? {
        let connectionFactory = ConnectionFactory(logger: Logger.shared)
        let applicationHandler = ApplicationHandler()
        let connectionPool = ConnectionPool(connectionFactory: connectionFactory,
                                            applicationHandler: applicationHandler)
        let connection = try? connectionPool.setupConnection()
        return connection
    }
    
    private func getRuntimeProvider() -> RuntimeProviderProtocol? {
        let fileRepository = FileRepository()
        let fileOperationFactory = RuntimeFilesOperationFactory(repository: fileRepository,
                                                                directoryPath: "")

        let dataStorageFacade = SubstrateDataStorageFacade.shared
        let dataOperationFactory = DataOperationFactory()
        let runtimeMetadataRepository: CoreDataRepository<RuntimeMetadataItem, CDRuntimeMetadataItem> = dataStorageFacade.createRepository()
        let runtimeProviderFactory = RuntimeProviderFactory(fileOperationFactory: fileOperationFactory,
                                                            repository: AnyDataProviderRepository(runtimeMetadataRepository),
                                                            dataOperationFactory: dataOperationFactory,
                                                            eventCenter: EventCenter.shared,
                                                            operationQueue: OperationManagerFacade.runtimeSyncQueue)

        let runtimeProvider = runtimeProviderFactory.createRuntimeProvider(for: chainModel)
        return runtimeProvider
    }
    
//    func test() throws {
//        let chainId = "b0a8d493285c2df73290dfb7e61f870f17b41801197a149ca93654499ea3dafe" //FREQUENCY
//        let selectedAddress = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY" //ALICE
//        let recipientAddress = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty" //BOB
//        let selectedAccountId = try selectedAddress.toAccountId()
//        let recipientAccountId = try recipientAddress.toAccountId()
//
//        let chainModel = getChainModel()
//        guard let connection = try? getConnection() else { return }
//        guard let runtimeProvider = try? getRuntimeProvider() else { return }
//
//        let extrinsicService = ExtrinsicService(accountId: selectedAccountId,
//                                                chain: chainModel,
//                                                cryptoType: .sr25519,
//                                                runtimeRegistry: runtimeProvider,
//                                                engine: connection,
//                                                operationManager: OperationManagerFacade.sharedManager)
//
//        let callFactory = SubstrateCallFactory()
//        let closure: ExtrinsicBuilderClosure = { builder in
//            let call = callFactory.nativeTransfer(to: recipientAccountId, amount: 1)
//            _ = try builder.adding(call: call)
//            return builder
//        }
//
//        //MARK: SIGNER
//        let chainAccountResponse = ChainAccountResponse(chainId: chainId,
//                                                        accountId: selectedAccountId,
//                                                        publicKey: <#T##Data#>,
//                                                        name: "Frequency",
//                                                        cryptoType: .sr25519,
//                                                        addressPrefix: 42,
//                                                        isEthereumBased: false,
//                                                        isChainAccount: true)
//        let signer = SigningWrapper(keystore: Keychain(),
//                                    metaId: "",
//                                    accountResponse: chainAccountResponse)
//
//        extrinsicService.submit(closure,
//                                signer: signingWrapper,
//                                runningIn: .main) { result in
//            switch result {
//            case let .success(paymentInfo):
//                if
////                    let feeValue = BigUInt(paymentInfo.fee),
////                    let fee = Decimal.fromSubstrateAmount(feeValue, precision: assetPrecision),
////                    fee > 0 {
//                    feeExpectation.fulfill()
//                } else {
//                    XCTFail("Cant parse fee")
//                }
//            case let .failure(error):
//                XCTFail(error.localizedDescription)
//            }
//    }
//    }
}

extension TestViewController {
//    func getEstimateFeeForBondExtraCall() throws {
//        let selectedAddress = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY" //Alice's address
//        let selectedAccountId = try selectedAddress.toAccountId()
//        let assetPrecision: Int16 = 12
//
////        let storageFacade = SubstrateStorageTestFacade()
////        let chainRegistry = ChainRegistryFacade.setupForIntegrationTest(with: storageFacade)
////        let connection = chainRegistry.getConnection(for: chainId)!
////        let runtimeService = chainRegistry.getRuntimeProvider(for: chainId)!
//
//        guard let connection = try? getConnection() else { return }
//        guard let runtimeProvider = try? getRuntimeProvider() else { return }
//
//        let extrinsicService = ExtrinsicService(
//            accountId: selectedAccountId,
//            chain: chainModel,
//            cryptoType: .sr25519,
//            runtimeRegistry: runtimeProvider,
//            engine: connection,
//            operationManager: OperationManagerFacade.sharedManager
//        )
//
//        let closure = createExtrinsicBuilderClosure(amount: 10)
//        extrinsicService.estimateFee(closure, runningIn: .main) { result in
//            switch result {
//            case let .success(paymentInfo):
//                if
//                    let feeValue = BigUInt(paymentInfo.fee),
//                    let fee = Decimal.fromSubstrateAmount(feeValue, precision: assetPrecision),
//                    fee > 0 {
////                    feeExpectation.fulfill()
//                } else {
//                    print("fail")
//                }
//            case let .failure(error):
//                print("fail")
//            }
//        }
//    }
    
//    private func createExtrinsicBuilderClosure(amount: BigUInt) -> ExtrinsicBuilderClosure {
//        let callFactory = SubstrateCallFactory()
//
//        let closure: ExtrinsicBuilderClosure = { builder in
//            let call = callFactory.bondExtra(amount: amount)
//            _ = try builder.adding(call: call)
//            return builder
//        }
//
//        return closure
//    }
    
    //MARK: JSONRPC
    private func createBlockHashOperation(
        connection: JSONRPCEngine,
        for numberClosure: @escaping () throws -> BlockNumber
    ) -> BaseOperation<String> {
        let requestOperation = JSONRPCListOperation<String>(
            engine: connection,
            method: RPCMethod.getBlockHash
        )

        requestOperation.configurationBlock = {
            do {
                let blockNumber = try numberClosure()
                requestOperation.parameters = [blockNumber.toHex()]
            } catch {
                requestOperation.result = .failure(error)
            }
        }

        return requestOperation
    }
    
    func getRunTimeVersion() {
        guard let url = URL(string: localNodeString) else { return }
        let logger = Logger.shared
        let operationQueue = OperationQueue()

        let engine = WebSocketEngine(urls: [url], logger: logger)!

        let operation = JSONRPCListOperation<RuntimeVersion>(engine: engine,
                                                             method: "chain_getRuntimeVersion",
                                                             parameters: [])

        operationQueue.addOperations([operation], waitUntilFinished: true)

        do {
            let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
            logger.debug("Received response: \(result)")
        } catch {
            print("Fail")
        }
    }
    
//    func getBlockHash(for block: UInt32) throws {
//        var block: UInt32 = block
//
//        guard let url = URL(string: localNodeString) else { return }
//        let logger = Logger.shared
//
//        let data = Data(Data(bytes: &block, count: MemoryLayout<UInt32>.size).reversed())
//
//        let engine = WebSocketEngine(urls: [url], logger: logger)!
//
//        let operation = JSONRPCListOperation<String?>(engine: engine,
//                                                      method: RPCMethod.getBlockHash,
//                                                      parameters: [data.toHex(includePrefix: true)])
//
//        OperationQueue().addOperations([operation], waitUntilFinished: true)
//
//        do {
//            let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
//            logger.debug("Received response: \(result!)")
//        } catch {
//            print("Fail")
//        }
//    }
}
