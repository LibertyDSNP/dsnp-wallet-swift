//
//  CongratsViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/9/23.
//

import UIKit
import SwiftUI
import Combine

class CongratsViewModel: ObservableObject {
    let finishAction = PassthroughSubject<Void, Never>()
    let skipAction = PassthroughSubject<Void, Never>()
}

class CongratsViewController: UIHostingController<CongratsModal> {
    let viewModel: CongratsViewModel
    
    var cancellables = [AnyCancellable]()
    
    init(viewModel: CongratsViewModel = CongratsViewModel()) {
        self.viewModel = viewModel
        super.init(rootView: CongratsModal(viewModel: self.viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
    }
    
    private func setupObservables() {
        viewModel.finishAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                // TODO: Respond to Finish ID action
                
            }
            .store(in: &cancellables)
        viewModel.skipAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                // TODO: Respond to Skip action
                
            }
            .store(in: &cancellables)
    }
}
