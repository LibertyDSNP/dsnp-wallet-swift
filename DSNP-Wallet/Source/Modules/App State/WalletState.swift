//
//  WalletState.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import Foundation

class AppState: ObservableObject {
    
    static let shared = AppState()

    @Published var isLoggedin = true
}
