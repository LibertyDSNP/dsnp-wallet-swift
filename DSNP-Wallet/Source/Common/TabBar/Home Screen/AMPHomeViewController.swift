//
//  HomeViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import UIKit
import SwiftUI
import Combine

class AMPHomeViewController: UIHostingController<HomeTabView> {

    let viewModel: HomeViewModel
    
    private var cancellables = [AnyCancellable]()
    
    var chosenHandle: String?
    
    init(viewModel: HomeViewModel = HomeViewModel(), showCongrats: Bool = false, chosenHandle: String?) {
        self.viewModel = viewModel
        self.viewModel.chosenHandle = chosenHandle
        super.init(rootView: HomeTabView(viewModel: viewModel, presentAlert: showCongrats))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
