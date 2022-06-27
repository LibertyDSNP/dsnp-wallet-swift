//
//  AuthManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/31/22.
//

import Foundation
import DSNPWallet

enum KeysError: Error {
    case delete
}

class AuthManager {
    static let shared = AuthManager()
    
    let akcManager = AccountKeychain()
    var accessPin: String? {
        get {
            return akcManager.accessPin
        }
        set {
            akcManager.accessPin = newValue
        }
    }
    
    func validatePin(_ pin: String?) -> Bool {
        return akcManager.validatePin(pin)
    }
    
    func loadKeys(authRequired: Bool = false) -> DSNPKeys? {
        if authRequired,
           !akcManager.isAuthorized {
            return nil
        }
        
        do {
            if let keys = try DSNPWallet().loadKeys() {
                return keys
            }
        } catch {
            print("Error")
        }
        
        return nil
    }
    
    func logout() throws {
        do {
            let _ = try DSNPWallet().deleteKeys()
            akcManager.clearAuthorization()
        } catch {
            throw KeysError.delete
        }
    }
}
