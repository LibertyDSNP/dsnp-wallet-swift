import Foundation
import SubstrateSdk
import BigInt

struct AddPublicKeyToMsaCall: Codable {
    enum CodingKeys: String, CodingKey {
        case msaOwnerPublicKey = "msa_owner_public_key"
        case msaOwnerProof = "msa_owner_proof"
        case newKeyOwnerProof = "new_key_owner_proof"
        case addKeyPayload = "add_key_payload"
    }
    
    let msaOwnerPublicKey: AccountId
    let msaOwnerProof: MultiSignature
    let newKeyOwnerProof: MultiSignature
    let addKeyPayload: AddKeyData
}

struct AddKeyData: Codable {
    enum CodingKeys: String, CodingKey {
        case msaId
        case expiration
        case newPublicKey
    }
    
    @StringCodable var msaId: UInt64
    @StringCodable var expiration: UInt32
    var newPublicKey: AccountId
}
