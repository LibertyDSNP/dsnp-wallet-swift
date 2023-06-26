//
//  SeedManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 3/22/23.
//
import SoraKeystore
import IrohaCrypto
import SubstrateSdk

//This class should strictly handle:
// i)   generation of seed phrase
// ii)  derivation of seed phrase
class SeedManager {
    static let shared = SeedManager()
    
    let keychainService = "com.unfinished.dsnp-wallet"
    let keychainAccount = "1625961730" //App ID on App Store
        
    func generateMnemonic() -> String? {
        guard let result = generateSeed() else { return nil }
        
        return result.mnemonic.toString()
    }
    
    func getKeypair(mnemonic: String) -> IRCryptoKeypairProtocol? {
        let seedFactory = SeedFactory(mnemonicLanguage: .english)
        
        guard let seedResult = try? seedFactory.deriveSeed(from: mnemonic, password: "") else {
            return nil
        }
        
        let keypair = try? SR25519KeypairFactory().createKeypairFromSeed(
            seedResult.seed.miniSeed,
            chaincodeList: []
        )
        
        return keypair
    }
    
    private func generateSeed() -> SeedFactoryResult? {
        let seedFactory = SeedFactory(mnemonicLanguage: .english)
        
        return try? seedFactory.createSeed(from: "", strength: .entropy128)
    }
}

//MARK: Keychain/SE Handling
extension SeedManager {
    func save(_ mnemonic: String) {
        guard let mnemonicData = mnemonic.data(using: .utf8) else {
            print("Error converting mnemonic to data")
            return
        }
        
        let accessControlError = UnsafeMutablePointer<Unmanaged<CFError>?>.allocate(capacity: 1)
        defer {
            accessControlError.deallocate()
        }
        
        guard let accessControl = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .userPresence,
            accessControlError
        ) else {
            if let error = accessControlError.pointee?.takeRetainedValue() {
                print("Error creating access control: \(error)")
            } else {
                print("Unknown error creating access control")
            }
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: mnemonicData,
            kSecAttrAccessControl as String: accessControl
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Mnemonic saved to keychain")
        } else if status == errSecDuplicateItem {
            print("Mnemonic already exists in keychain")
        } else {
            print("Error saving mnemonic to keychain: \(status)")
        }
    }
    
    func fetch() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let retrievedData = item as? Data else {
            print("Error retrieving mnemonic from keychain: \(status)")
            return nil
        }
        
        return String(data: retrievedData, encoding: .utf8)
    }
    
    func delete() -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        return SecItemDelete(query as CFDictionary)
    }
}
