//
//  ConfirmHandleViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import UIKit
import SwiftUI
import Combine

class ConfirmHandleViewController: UIHostingController<ConfirmHandleView> {
    
    let viewModel: ConfirmHandleViewModel
    
    private var cancellables = [AnyCancellable]()
    
    init(chosenHandle: String) {
        self.viewModel = ConfirmHandleViewModel(chosenHandle: chosenHandle)
        super.init(rootView: ConfirmHandleView(viewModel: self.viewModel))
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
                self.navigationController?.pushViewController(AgreeToTermsViewController(chosenHandle: self.viewModel.chosenHandle), animated: true)
            }
            .store(in: &cancellables)
    }
}
