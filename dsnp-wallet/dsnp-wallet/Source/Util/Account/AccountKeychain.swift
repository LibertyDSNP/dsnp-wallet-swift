//
//  AccountKeychain.swift
//  DSNP-Wallet
//
//  Created by Rigo Carbajal on 6/8/21.
//

import Foundation

class AccountKeychain {
    private let kAccessPin = "access_pin"
    var isAuthorized: Bool = false {
        didSet {
            guard isAuthorized else { return }
            NotificationCenter.default.post(name: Notification.Name(NotificationType.retrievedKeys.rawValue),
                                            object: nil)
        }
    }

    var accessPin: String? {
        get {
            return Keychain.shared[kAccessPin]
        }
        set {
            Keychain.shared[kAccessPin] = newValue
        }
    }
    
    func validatePin(_ pin: String?) -> Bool {
        if accessPin != nil {
            isAuthorized = pin == accessPin
        } else {
            accessPin = pin
            isAuthorized = true
        }
        return isAuthorized
    }
    
    public func clearAuthorization() {
        self.accessPin = nil
        isAuthorized = false
    }
}
