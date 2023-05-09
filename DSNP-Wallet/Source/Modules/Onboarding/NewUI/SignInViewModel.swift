//
//  SignInViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/5/23.
//

import UIKit
import Combine

class SignInViewModel: ObservableObject {

    // Actions
    var createIdentityAction = PassthroughSubject<Void, Never>()
    var meWeIdAction = PassthroughSubject<Void, Never>()
    var restoreAction = PassthroughSubject<Void, Never>()

}
