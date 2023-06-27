//
//  ImportSeedViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/27/23.
//

import UIKit
import SwiftUI
import Combine

struct ImportSeedViewControllerWrapper : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = ImportSeedViewController
    
    func updateUIViewController(_ uiViewController: ImportSeedViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> ImportSeedViewController {
        return ImportSeedViewController(viewModel: ImportSeedViewModel())
    }
}

class ImportSeedViewController: UIHostingController<ImportSeedView> {
    
    let viewModel: ImportSeedViewModel
    
    private var cancellables = [AnyCancellable]()
    
    init(viewModel: ImportSeedViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ImportSeedView(viewModel: self.viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
        
    }
    
    private func setupObservables() {
        viewModel.$user.sink { [weak self] user in
            guard let self else { return }
            if let user {
                let tabVC = AMPHomeViewController(user: user, showCongrats: true, chosenHandle: "")
                self.navigationController?.setViewControllers([tabVC], animated:true)
            }
        }
        .store(in: &cancellables)
    }
}
