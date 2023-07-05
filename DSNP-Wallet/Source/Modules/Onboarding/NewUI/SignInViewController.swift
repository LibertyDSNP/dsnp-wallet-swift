//
//  SignInViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import UIKit
import SwiftUI

class SignInViewController: UIHostingController<SignInView> {

    let viewModel: SignInViewModel = SignInViewModel()
        
    init() {
        super.init(rootView: SignInView(viewModel: viewModel))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }

}
