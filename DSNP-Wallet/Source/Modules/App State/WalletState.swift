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
    
    func setSocialIdentityProgressState(state: SocialIdentityProgressState) {
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: "onboardingState")
        }
    }
    
    func socialIdentityProgressState() -> SocialIdentityProgressState? {
        if let data = UserDefaults.standard.object(forKey: "onboardingState") as? Data,
            var state = try? JSONDecoder().decode(SocialIdentityProgressState.self, from: data) {
            state.isHandleCreated = !AppState.shared.handle.isEmpty
            return state
        }

        let defaultState = SocialIdentityProgressState()
        if let encoded = try? JSONEncoder().encode(defaultState) {
            UserDefaults.standard.set(encoded, forKey: "onboardingState")
        }
        return defaultState
    }
    
    func resetSocialProgress() {
        let defaultState = SocialIdentityProgressState()
        if let encoded = try? JSONEncoder().encode(defaultState) {
            UserDefaults.standard.set(encoded, forKey: "onboardingState")
        }
    }
}
