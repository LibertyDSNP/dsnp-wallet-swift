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
    
    func logout() throws {
        do {
            let _ = try DSNPWallet().deleteKeys()
            AccountKeychain.shared.clearAuthorization()
        } catch {
            throw KeysError.delete
        }
    }
}
