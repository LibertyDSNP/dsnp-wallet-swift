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
    
    func addPublicKeyToMsa(msaId: UInt64,
                           expiration: UInt32,
                           primaryUser: UserFacadeProtocol,
                           secondaryUser: UserFacadeProtocol,
                           subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                           notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) throws {
        guard let primarySigner = primaryUser.signer,
              let secondarySigner = secondaryUser.signer,
              let primaryPublicKeyData = primaryUser.publicKey?.rawData(),
              let secondaryAccountId = secondaryUser.getAccountId() else {
            throw ExtrinsicError.BadSetup
        }
        
        let addKeyPayload = AddKeyData(msaId: msaId,
                                       expiration: expiration,
                                       newPublicKey: secondaryAccountId)
        
        self.extrinsicService?.scaleEncode(addKeyPayload,
                                           runningIn: .main,
                                           completion: { scaleEncodedData in
            guard let data = scaleEncodedData,
                  let msaOwnerProof = try self.scaleEncodeWithBytesTags(payload: data,
                                                                        signedBy: primarySigner),
                  let newOwnerProof = try self.scaleEncodeWithBytesTags(payload: data,
                                                                        signedBy: secondarySigner)else { return }
            
            let closure: ExtrinsicBuilderClosure = { builder in
                let call = self.callFactory.addPublicKeyToMsa(msaOwnerPublicKey: primaryPublicKeyData,
                                                              msaOwnerProof: msaOwnerProof,
                                                              newKeyOwnerProof: newOwnerProof,
                                                              addKeyPayload: addKeyPayload)
                
                _ = try builder.adding(call: call)
                
                
                return builder
            }
            
            self.extrinsicService?.submitAndWatch(closure,
                                                  signer: primarySigner,
                                                  runningIn: .main,
                                                  subscriptionIdClosure: subscriptionIdClosure,
                                                  notificationClosure: notificationClosure)
        })
    }
}
