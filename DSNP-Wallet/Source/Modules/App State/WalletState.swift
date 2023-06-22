//
//  WalletState.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import Foundation
import DSNPWallet

/*
 Problem statement
 
 Social ID progress is not published and updated in a view thats already been drawn. We also
 - need to clean up how we're managing this data: Handle, avatar created, backed up seed
 - Make elements published and observed in correct places
 - Steps achieved to be a dynamic var checking the below values
 
 How
 
 - Make app state published
 - Have values be derived from current vals at run time.
 > Avatar checked from current profile photo value
 > Handle checked from user defaults
 > Seed backed up from user defaults
 
 - Publish changes when value is changed
 
 */

enum AppStateKeys: String {
    case onboardingStateKey = "onboardingState"
    case backedUpSeedPhraseKey = "seedPhraseBackedUp"
    case avatarSetKey = "avatarSet"
}

class AppState: ObservableObject {

    static let shared = AppState()

    @Published var isLoggedin = true
    
    public let socialIdentityStepCount = 3
    
    private (set) var handle = {
        if let handle = UserDefaults.standard.object(forKey: "handle") {
            return handle as? String ?? ""
        }
        return ""
    }()
    
    func doKeysExist() -> Bool {
        do {
            let keys = try DSNPWallet().loadKeys()
            return keys != nil
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
    
    // MARK: Social Progress State
    
    func setHandle(handle: String) {
        if !handle.isEmpty {
            UserDefaults.standard.set(handle, forKey: "handle")
        }
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
    
    func setCreateAvatar(created: Bool) {
        UserDefaults.standard.set(created, forKey: AppStateKeys.avatarSetKey.rawValue)
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
    
    func setBackedUp(backedUp: Bool) {
        setDidBackupSeedPhrase(backedUp: backedUp)
    }
}
