//
//  ClaimHandleViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/5/23.
//

import UIKit
import SwiftUI
import Combine

class ClaimHandleViewController: UIHostingController<ClaimHandleView> {

    let viewModel: ClaimHandleViewModel
    
    private var cancellables = [AnyCancellable]()
    
    init(viewModel: ClaimHandleViewModel = ClaimHandleViewModel()) {
        self.viewModel = viewModel
        super.init(rootView: ClaimHandleView(viewModel: viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
    }
    
    private func setupObservables() {
        viewModel.nextAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                self.navigationController?.pushViewController(ConfirmHandleViewController(chosenHandle: self.viewModel.claimHandleText), animated: true)
            }
            .store(in: &cancellables)
        viewModel.skipAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                let agreeVC = AgreeToTermsViewController(chosenHandle: "")
                self.navigationController?.pushViewController(agreeVC, animated: true)
            }
            .store(in: &cancellables)
        viewModel.backAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
}
