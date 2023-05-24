//
//  AgreeToTermsViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import UIKit
import Combine

class AgreeToTermsViewModel: ObservableObject {
    
    let chosenHandle: String
    
    let agreeAction = PassthroughSubject<Void, Never>()
    
    init(chosenHandle: String) {
        self.chosenHandle = chosenHandle
    }
}
