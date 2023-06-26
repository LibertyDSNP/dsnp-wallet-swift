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
    @Published var hasBackedKeys = false
    
    private (set) var handle = {
        if let handle = UserDefaults.standard.object(forKey: "handle") {
            return handle as? String ?? ""
        }
        return ""
    }()
    
    func doKeysExist() -> Bool {
        do {
            let keysExist = try AccountKeychain().checkKey()
            return keysExist
        } catch {
            return false
        }
    }
    
    func faceIdEnabled() -> Bool {
        if let enabled = UserDefaults.standard.object(forKey: "faceId") {
            return enabled as? Bool ?? false
        }
        
        let defaultState = false
        UserDefaults.standard.set(defaultState, forKey: "faceId")
        return defaultState
    }
    
    func setFaceIdEnabled(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "faceId")
    }
    
    func setHandle(handle: String) {
        if !handle.isEmpty {
            UserDefaults.standard.set(handle, forKey: "handle")
        }
    }
}
