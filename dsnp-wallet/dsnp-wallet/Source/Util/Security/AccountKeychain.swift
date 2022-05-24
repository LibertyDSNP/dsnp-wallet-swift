//
//  AccountKeychain.swift
//  DSNP-Wallet
//
//  Created by Rigo Carbajal on 6/8/21.
//

import Foundation

class AccountKeychain {
    static var shared = AccountKeychain()
    
    private let kAccessPin = "access_pin"
    
    var accessPin: String? {
        get {
            return Keychain.shared[kAccessPin]
        }
        set {
            Keychain.shared[kAccessPin] = newValue
        }
    }
    
    public func clearAuthorization() {
        self.accessPin = nil
    }
}
