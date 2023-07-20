//
//  ExtrinsicManager+Balances.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 2/22/23.
//

import Foundation
import RobinHood
import SubstrateSdk
import BigInt

extension ExtrinsicManager {
    func transfer(amount: BigUInt,
                  toAddress: String,
                  subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                  notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) throws {
        let amountInToken = amount * Currency.dollar.rawValue
        
        guard let toAccountId = try? toAddress.toAccountId(using: .substrate(FrequencyChain.shared.prefixValue)) else { return }
        
        let closure: ExtrinsicBuilderClosure = { builder in
            let call = self.callFactory.nativeTransfer(to: toAccountId, amount: amountInToken)
            _ = try builder.adding(call: call)
            return builder
        }
        
        guard let signer = user?.signer else { throw ExtrinsicError.setup }
        
        extrinsicService?.submitAndWatch(closure,
                                         signer: signer,
                                         runningIn: .main,
                                         subscriptionIdClosure: subscriptionIdClosure,
                                         notificationClosure: notificationClosure)
    }
}
