//
//  TabBarViewModel.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/12/22.
//

import Foundation
import DSNPWallet

class TabBarViewModel {
    var user: User?
    var updateUserBlock: ((UserFacadeProtocol)->())?
    
    init(user: User) {
        self.user = user
    }
}
