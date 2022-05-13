//
//  User.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 5/11/22.
//

import Foundation
import DSNPWallet

protocol User: AnyObject {
    var name: String? { get }
    var keys: DSNPKeys? { get }
}

//Only allow updating Users from TabBarVC 
class OpenUser: User {
    private(set) var name: String?
    private(set) var keys: DSNPKeys?
    
    convenience init(keys: DSNPKeys) {
        self.init()
        self.keys = keys
    }
    
    func set(_ name: String) {
        self.name = name
    }
}
