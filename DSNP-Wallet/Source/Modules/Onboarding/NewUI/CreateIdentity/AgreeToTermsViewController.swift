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
                if let seed = SeedManager.shared.generateMnemonic() {
                    // Check if seed saves successfully
                    if !self.saveSeed(seed: seed) {
                        // TODO: Handle Error
                        return
                    }

                    do {
                        let user = try User(mnemonic: seed)
                        
                        let tabVC = AMPHomeViewController(user: user, showCongrats: true, chosenHandle: self.viewModel.chosenHandle)
                        self.navigationController?.setViewControllers([tabVC], animated:true)
                    } catch {
                        // TODO: Handle Error
                    }
                }
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
    
    private func saveSeed(seed: String) -> Bool {
        do {
            try SeedManager.shared.save(seed)
            return true
        } catch let error as SeedManagerError {
            let alert = UIAlertController(title: "Error Creating Seed Phrase", message: error.errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "remove old one", style: .default, handler: { action in
                do {
                    try SeedManager.shared.delete()
                } catch {
                    print("delete error: \(error)")
                }
            }))
            self.present(alert, animated: true)
        } catch {
            print(error)
        }
        return false
    }
}
