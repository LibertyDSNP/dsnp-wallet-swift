import Foundation
import SubstrateSdk
import BigInt

// msaOwnerPublicKey is explicitly defined in case this is called by a
// separate account, unrelated to the msaOwner and newOwner.
// We signed the `addKeyPayload` with both the msaOwner keys and the
// newKeyOwner keys.
// The proofs validate there's appropriate authority for this extrinsic.

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
    let addKeyPayload: AddKeyPayloadArg
}

struct AddKeyPayloadArg: Codable {
    @StringCodable var msaId: UInt64
    @StringCodable var expiration: UInt32
    var newPublicKey: AccountId
}
