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
}

struct SocialIdentityProgressState: Codable {
    var isHandleCreated: Bool = false
    var isSeedPhraseBacked: Bool = false
    var isAvatarCreated: Bool = false
    
    static let numberOfSteps = 3
    
    func totalStepsAchieved() -> Int {
        var count = 0
        if isHandleCreated {
            count += 1
        }
        if isSeedPhraseBacked {
            count += 1
        }
        if isAvatarCreated {
            count += 1
        }
        return count
    }
    
    func isComplete() -> Bool {
        return isHandleCreated && isSeedPhraseBacked && isAvatarCreated
    }
}

class AppState: ObservableObject {

    static let shared = AppState()

    @Published var isLoggedin = true
    @Published var hasBackedKeys = false
    
    @Published var socialIdentityProgressState: SocialIdentityProgressState = {
        var socialIdProgressState = SocialIdentityProgressState()
        socialIdProgressState.isHandleCreated = {
            let handle = UserDefaults.standard.string(forKey: "handle")
            return handle != nil && !(handle?.isEmpty ?? false)
        }()
        
        socialIdProgressState.isSeedPhraseBacked = UserDefaults.standard.bool(forKey: AppStateKeys.backedUpSeedPhraseKey.rawValue)
        return socialIdProgressState
    }()
    
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

    // MARK: Social Identity
    
    func resetSocialProgress() {
        clearHandle()
        setDidBackupSeedPhrase(backedUp: false)
    }
    
    func socialIdentityProgressStepsCompleted() -> Int {
        return socialIdentityProgressState.totalStepsAchieved()
    }
    
    func setBackedUp(backedUp: Bool) {
        setDidBackupSeedPhrase(backedUp: backedUp)
        socialIdentityProgressState.isSeedPhraseBacked = backedUp
    }
}
