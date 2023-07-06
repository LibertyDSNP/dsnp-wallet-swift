//
//  WalletState.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import Foundation
import DSNPWallet

enum AppStateKeys: String {
    case backedUpSeedPhraseKey = "seedPhraseBackedUp"
    case avatarSetKey = "avatarSet"
}

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
    
    func clearHandle() {
        UserDefaults.standard.set("", forKey: "handle")
    }
    
    func didBackupSeedPhrase() -> Bool {
        return UserDefaults.standard.bool(forKey: AppStateKeys.backedUpSeedPhraseKey.rawValue)
    }
    
    func setDidBackupSeedPhrase(backedUp: Bool) {
        UserDefaults.standard.set(backedUp, forKey: AppStateKeys.backedUpSeedPhraseKey.rawValue)
    }
    
    func didCreateAvatar() -> Bool {
        return UserDefaults.standard.bool(forKey: AppStateKeys.backedUpSeedPhraseKey.rawValue)
    }

    
    func resetSocialProgress() {
        clearHandle()
        setDidBackupSeedPhrase(backedUp: false)
    }

    func socialIdentityProgressStepsCompleted() -> Int {
        var count = 0
        if !handle.isEmpty {
            count += 1
        }
        if didBackupSeedPhrase() {
            count += 1
        }
        if didCreateAvatar() {
            count += 1
        }
        return count
    }

}
extension UserDefaults {
   static func setHandle(with value: String) {
     UserDefaults.standard.set(value, forKey: "handle")
   }

  static func getHandle() -> String {
    return UserDefaults.standard.string(forKey: "handle") ?? ""
  }
}

extension UserDefaults {
    @objc var seedBackedUp: Bool {
        get {
            return Bool(AppStateKeys.backedUpSeedPhraseKey.rawValue) ?? false
        }
        set {
            set(newValue, forKey: AppStateKeys.backedUpSeedPhraseKey.rawValue)
        }
    }
    
    @objc var didCreateAvatar: Bool {
        get {
            return Bool(AppStateKeys.avatarSetKey.rawValue) ?? false
        }
        set {
            set(newValue, forKey: AppStateKeys.avatarSetKey.rawValue)
        }
    }
}
