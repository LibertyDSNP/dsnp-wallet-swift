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

//MARK: Secure Enclave Wrapper
extension AccountKeychain {
    func save(mnemonic: String) throws {
        guard let dataToSave = mnemonic.data(using: .utf8),
              let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryAny, nil) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "Mnemonic",
            kSecAttrService as String: "com.example.app",
            kSecUseAuthenticationContext as String: LAContext(),
            kSecValueData as String: dataToSave,
            kSecAttrAccessControl as String: access,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw NSError(domain: "com.example.app", code: Int(status), userInfo: nil)
        }
    }
    
//    func save(mnemonic: String) throws {
//        guard let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .biometryAny, nil) else { return }
//
//        let keychainQuery: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: "com.example.app.service",
//            kSecUseDataProtectionKeychain as String: true,
//            kSecAttrAccessControl as String: access
//        ]
//
//        let status = SecItemAdd(keychainQuery as CFDictionary, mnemonic.utf8CString, mnemonic.utf8CString.count, nil)
//
//        return status
//    }

    func getMnemonic() -> String? {
        // Set up a query dictionary to retrieve the Keychain item
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "Mnemonic",
            kSecReturnData as String: true,
            kSecUseOperationPrompt as String: "Authenticate to retrieve password"
        ]

        // Create a context for biometric authentication
        let context = LAContext()
        context.interactionNotAllowed = true

        // Attempt to retrieve the Keychain item
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data, let password = String(data: data, encoding: .utf8) {
            // Biometric authentication succeeded, and the password was retrieved from the Keychain
            return password
//            print("Password: \(password)")
        } else {
            // Biometric authentication failed, or the Keychain item could not be retrieved
//            print("Err/or retrieving password: \(status)")
            return nil
        }
    }
}
