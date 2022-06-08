//
//  UserAPI.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 6/7/22.
//

import Foundation
import DSNPWallet

class UserAPI: BaseAPI {
    
    static let shared = UserAPI()
    
    private func loginUser(keys: DSNPKeys,
                           didReceiveAuthorization: (() -> Void)?,
                           didCompleteWithError: ((Error?) -> Void)?) {
        
    }
}
