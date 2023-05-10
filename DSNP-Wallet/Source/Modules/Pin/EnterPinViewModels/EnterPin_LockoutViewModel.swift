//
//  EnterPin_LockoutViewModel.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/16/21.
//

import Foundation

class EnterPin_LockoutViewModel {
    
    public var lock: (() -> Void)?
    public var unlock: (() -> Void)?
    
    public var isLockedOut: Bool {
        if let lockoutTime = self.lockoutTime {
            if lockoutTime.addingTimeInterval(self.lockoutDuration) >= Date() {
                return true
            }
        }
        
        return false
    }
    
    private var numUnlockAttempts = 0
    private var maxUnlockAttempts = 5
    private var lockoutDuration: Double = 60 * 10
    private var lockoutTimer: Timer?
    private var kLockoutTime = "lockout_time"
    private var lockoutTime: Date? {
        get {
            return UserDefaults.standard.object(forKey: self.kLockoutTime) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.kLockoutTime)
            UserDefaults.standard.synchronize()
        }
    }
    
    public func updateState() {
        if self.isLockedOut {
            self.lockInput()
        } else {
            self.unlockInput()
        }
    }
    
    public func incrementUnlockAttempt() {
        self.numUnlockAttempts += 1
        if self.numUnlockAttempts >= self.maxUnlockAttempts {
            self.lockoutTime = Date()
            self.lockInput()
        }
    }
    
    private func startUnlockTimer() {
        if let lockoutTime = self.lockoutTime {
            let unlockTime = lockoutTime.addingTimeInterval(self.lockoutDuration)
            let currentTime = Date()
            if unlockTime > currentTime {
                let secondsTillUnlock = unlockTime.timeIntervalSince(currentTime)
                if secondsTillUnlock > 0 {
                    self.lockoutTimer?.invalidate()
                    self.lockoutTimer = Timer.scheduledTimer(withTimeInterval: secondsTillUnlock, repeats: false, block: { timer in
                        self.updateState()
                    })
                }
            }
        }
    }
    
    private func lockInput() {
        self.lock?()
        self.startUnlockTimer()
    }
    
    private func unlockInput() {
        self.unlock?()
    }
}
