//
//  SeedManager.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 3/22/23.
//
import SoraKeystore
import IrohaCrypto
import SubstrateSdk

enum SeedManagerError: Error {
    case mnemonicExists
    case accessControlError(message: String)
    case unknownAccessControlError
    case conversionError
    case genericErrorWithStatus(status: OSStatus)
    
    var errorMessage: String {
        switch self {
        case .mnemonicExists:
            return "A Mnemonic already exists for the given key"
        case .accessControlError(let message):
            return "Access Control denied. \(message)"
        case .unknownAccessControlError:
            return "Access Control denied"
        case .conversionError:
            return "Error converting data types"
        case .genericErrorWithStatus(let status):
            return "Error with status: \(status)"
        }
    }
}

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
    func save(_ mnemonic: String) throws {
        guard let mnemonicData = mnemonic.data(using: .utf8) else {
            throw SeedManagerError.conversionError
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
                throw SeedManagerError.accessControlError(message: error.localizedDescription)
            } else {
                throw SeedManagerError.unknownAccessControlError
            }
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
            throw SeedManagerError.mnemonicExists
        } else {
            throw SeedManagerError.genericErrorWithStatus(status: status)
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
    
    func delete() throws {
        
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
                throw SeedManagerError.accessControlError(message: error.localizedDescription)
            } else {
                throw SeedManagerError.unknownAccessControlError
            }
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecAttrAccessControl as String: accessControl,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw SeedManagerError.genericErrorWithStatus(status: status)
        }
    }
}
