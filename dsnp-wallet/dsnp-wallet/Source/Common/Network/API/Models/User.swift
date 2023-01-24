//
//  User.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 6/7/22.
//

import Foundation
import DSNPWallet

protocol User: AnyObject  {
    var name: String? { get }
    var keys: DSNPKeys? { get }
}

//Only allow updating Users from TabBarVC
class OpenUser: User, Equatable {
    private(set) var name: String?
    private(set) var keys: DSNPKeys?
    
    convenience init(keys: DSNPKeys) {
        self.init()
        self.keys = keys
    }
    
    func set(_ name: String) {
        self.name = name
    }
    
    static func == (lhs: OpenUser, rhs: OpenUser) -> Bool {
        return lhs.keys?.address == rhs.keys?.address
    }
}
