//
//  ConfirmHandleViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import UIKit
import Combine

class ConfirmHandleViewModel: ObservableObject {

    let chosenHandle: String
    
    var nextAction = PassthroughSubject<Void, Never>()
    var backAction = PassthroughSubject<Void, Never>()

    init(chosenHandle: String) {
        self.chosenHandle = chosenHandle
    }
}
