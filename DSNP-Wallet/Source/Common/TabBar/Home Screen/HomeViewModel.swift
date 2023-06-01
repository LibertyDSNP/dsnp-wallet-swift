//
//  HomeViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import UIKit

class HomeViewModel: ObservableObject {

    @Published var appStateLoggedIn = AppState.shared.isLoggedin
    
    func toggleLoggedInState() {
        appStateLoggedIn.toggle()
    }
}
