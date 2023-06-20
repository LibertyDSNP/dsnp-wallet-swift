//
//  AccountKeychain.swift
//  DSNP-Wallet
//
//  Created by Rigo Carbajal on 6/8/21.
//

import Foundation
import SoraKeystore
import Security
import LocalAuthentication

//Manages pin and wrapper for SoraKeyStore
class AccountKeychain {
    static var shared = AccountKeychain()
    let keystore: KeystoreProtocol = Keychain()
    
    let identifier = ""
    
    private let kAccessPin = "access_pin"
    private var isAuthorized: Bool = false {
        didSet {
            guard isAuthorized else { return }
            NotificationCenter.default.post(name: Notification.Name(NotificationType.retrievedKeys.rawValue),
                                            object: nil)
        }
    }

    var accessPin: String? {
        get {
            return self[kAccessPin]
        }
        set {
            self[kAccessPin] = newValue
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
    
    public func clearAuthorization() throws {
        try? deleteKey()
        self.accessPin = nil
        isAuthorized = false
    }
}

//Access Pin Subscript/Keychain Logic
extension AccountKeychain {
    public subscript(key: String) -> String? {
        get {
            return load(withKey: key)
        } set {
            DispatchQueue.global().sync(flags: .barrier) {
                self.save(newValue, forKey: key)
            }
        }
    }

    private func save(_ string: String?, forKey key: String) {
        let query = keychainQuery(withKey: key)
        let objectData: Data? = string?.data(using: .utf8, allowLossyConversion: false)
        if SecItemCopyMatching(query, nil) == noErr {
            if let dictData = objectData {
                let status = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
            } else {
                let status = SecItemDelete(query)
            }
        } else {
            if let dictData = objectData {
                query.setValue(dictData, forKey: kSecValueData as String)
                let status = SecItemAdd(query, nil)
            }
        }
    }

    private func load(withKey key: String) -> String? {
        let query = keychainQuery(withKey: key)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        guard
            let resultsDict = result as? NSDictionary,
            let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data,
            status == noErr
        else {
            return nil
        }
        return String(data: resultsData, encoding: .utf8)
    }

    private func keychainQuery(withKey key: String) -> NSMutableDictionary {
        let result = NSMutableDictionary()
        result.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        result.setValue(key, forKey: kSecAttrService as String)
        result.setValue(kSecAttrAccessibleWhenUnlocked, forKey: kSecAttrAccessible as String)
        return result
    }
}

//SoraKeystore Wrapper
extension AccountKeychain {
    func save(secretKey: Data) throws {
        try keystore.saveKey(secretKey, with: identifier)
    }
    
    func fetchKey() throws -> Data  {
        return try keystore.fetchKey(for: identifier)
    }
    
    func checkKey() throws -> Bool {
        return try keystore.checkKey(for: identifier)
    }
    
    func deleteKey() throws {
        return try keystore.deleteKey(for: identifier)
    }
}
