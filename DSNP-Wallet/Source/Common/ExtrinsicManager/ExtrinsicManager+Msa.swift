//
//  ExtrinsicManager+Msa.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 2/22/23.
//

import Foundation
import RobinHood
import SubstrateSdk

extension ExtrinsicManager {
    func createMSA(subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                   notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) throws {
        let closure: ExtrinsicBuilderClosure = { builder in
            let call = self.callFactory.createMsa()
            _ = try builder.adding(call: call)
            return builder
        }
        
        guard let signer = user?.signer else { throw ExtrinsicError.BadSetup }
                
        extrinsicService?.submitAndWatch(closure,
                                         signer: signer,
                                         runningIn: .main,
                                         subscriptionIdClosure: subscriptionIdClosure,
                                         notificationClosure: notificationClosure)
    }
    
    func addPublicKeyToMsa(primaryUser: UserFacadeProtocol,
                           secondaryUser: UserFacadeProtocol,
                           subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                           notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) throws {
        guard let primarySigner = primaryUser.signer,
              let secondarySigner = secondaryUser.signer,
              let primaryPublicKeyData = primaryUser.publicKey?.rawData(),
              let secondaryAccountId = secondaryUser.getAccountId() else {
            throw ExtrinsicError.BadSetup
        }
        
        let addKeyPayload = AddKeyPayloadArg(msaId: 1,
                                             expiration: 5,
                                             newPublicKey: secondaryAccountId)
        
        guard let keyPayloadData = try? JSONEncoder().encode(addKeyPayload) else {
            throw ExtrinsicError.BadSetup
        }
        let newOwnerRawSignature = try secondarySigner.sign(keyPayloadData).rawData()
        let msaOwnerRawSignature = try primarySigner.sign(keyPayloadData).rawData()
        
        let msaOwnerSignature = MultiSignature.sr25519(data: msaOwnerRawSignature)
        let newOwnerSignature = MultiSignature.sr25519(data: newOwnerRawSignature)
        
        let closure: ExtrinsicBuilderClosure = { builder in
            let call = self.callFactory.addPublicKeyToMsa(msaOwnerPublicKey: primaryPublicKeyData,
                                                          msaOwnerProof: msaOwnerSignature,
                                                          newKeyOwnerProof: newOwnerSignature,
                                                          addKeyPayload: addKeyPayload)
            _ = try builder.adding(call: call)
            return builder
        }
        
        extrinsicService?.submitAndWatch(closure,
                                         signer: primarySigner,
                                         runningIn: .main,
                                         subscriptionIdClosure: subscriptionIdClosure,
                                         notificationClosure: notificationClosure)
    }
}
