//
//  ChainEnvironment.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 4/28/23.
//

import Foundation

class ChainEnvironment {

    static let defaultWebSocketAddress = "ws://127.0.0.1:9944"
    
    static func resetNodeURL() {
        UserDefaults.standard.setValue(ChainEnvironment.defaultWebSocketAddress, forKey: "nodeURL")
    }
    
    static func getNodeURL() -> String {
        return UserDefaults.standard.object(forKey: "nodeURL") as? String ?? ChainEnvironment.defaultWebSocketAddress
    }

    static func setNodeURL(url: String) {
        if !url.isEmpty {
            UserDefaults.standard.setValue(url, forKey: "nodeURL")
        }
    }
}
