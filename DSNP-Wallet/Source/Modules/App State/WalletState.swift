//
//  WalletState.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import Foundation
import DSNPWallet

class AppState: ObservableObject {
    
    static let shared = AppState()

    @Published var isLoggedin = true
    
    func doKeysExist() -> Bool {
        do {
            let keys = try DSNPWallet().loadKeys()
            return keys != nil
        } catch {
            return false
        }
    }
}
