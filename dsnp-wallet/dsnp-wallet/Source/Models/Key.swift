//
//  Key.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 5/17/22.
//

import Foundation

class Key {
    var isRoot: Bool = false
    var title: String?
    var address: String?
    var isConnected: Bool = false
    var condensedAddress: String {
        get {
            guard let address = address else { return "" }
            if address.count > 10 {
                let prefix = address.prefix(4)
                let suffix = address.suffix(6)
                return "\(String(describing: prefix))...\(String(describing: suffix))"
            } else {
                return address
            }
        }
    }
    
    convenience init(isRoot: Bool = false, title: String?, address: String?, isConnected: Bool = false) {
        self.init()
        self.isRoot = isRoot
        self.title = title
        self.address = address
        self.isConnected = isConnected
    }
}
