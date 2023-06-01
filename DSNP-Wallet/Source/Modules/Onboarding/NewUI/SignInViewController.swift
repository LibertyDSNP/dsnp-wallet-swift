//
//  SignInViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import UIKit
import SwiftUI
import Combine

class SignInViewController: UIHostingController<SignInView> {

    let viewModel: SignInViewModel = SignInViewModel()
    
    private var cancellables = [AnyCancellable]()
    
    init() {
        super.init(rootView: SignInView(viewModel: viewModel))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupObservables()
    }

    private func setupObservables() {
        viewModel.createIdentityAction.sink { [weak self] in
            guard let self else { return }
            self.navigationController?.pushViewController(ClaimHandleViewController(), animated: true)
        }
        .store(in: &cancellables)
//        viewModel.meWeIdAction.sink { [weak self] in
//            guard let self else { return }
//
//        }
//        .store(in: &cancellables)
//        viewModel.restoreAction.sink { [weak self] in
//            guard let self else { return }
//
//        }
//        .store(in: &cancellables)
    }

}
