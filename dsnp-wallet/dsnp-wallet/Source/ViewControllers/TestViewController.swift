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

class TestViewController: UIViewController {
    
//    let localNodeString = "ws://127.0.0.1:9944"
//    
//    override func viewDidLoad() {
//        getRunTimeVersion()
//    }
//    
//    func getRunTimeVersion() {
//        guard let url = URL(string: localNodeString) else { return }
//        let logger = Logger.shared
//        let operationQueue = OperationQueue()
//
//        let engine = WebSocketEngine(urls: [url], logger: logger)!
//
//        let operation = JSONRPCListOperation<RuntimeVersion>(engine: engine,
//                                                             method: "chain_getRuntimeVersion",
//                                                             parameters: [])
//
//        operationQueue.addOperations([operation], waitUntilFinished: true)
//
//        do {
//            let result = try operation.extractResultData(throwing: BaseOperationError.parentOperationCancelled)
//            logger.debug("Received response: \(result)")
//        } catch {
//            print("Fail")
//        }
//    }
}
