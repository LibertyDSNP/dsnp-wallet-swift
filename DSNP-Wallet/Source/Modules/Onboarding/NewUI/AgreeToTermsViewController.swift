//
//  AgreeToTermsViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import UIKit
import SwiftUI
import Combine

class AgreeToTermsViewController: UIHostingController<AgreeToTermsView> {

    let viewModel: AgreeToTermsViewModel
    
    private var cancellables = [AnyCancellable]()
    
    init(chosenHandle: String) {
        self.viewModel = AgreeToTermsViewModel(chosenHandle: chosenHandle)
        super.init(rootView: AgreeToTermsView(viewModel: self.viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
    }
    
    private func setupObservables() {
        viewModel.agreeAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                self.navigationController?.pushViewController(CongratsViewController(), animated: true)
            }
            .store(in: &cancellables)
    }

}
