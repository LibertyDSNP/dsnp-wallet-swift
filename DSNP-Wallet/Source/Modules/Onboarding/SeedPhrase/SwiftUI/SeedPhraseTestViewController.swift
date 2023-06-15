//
//  SeedPhraseTestViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/16/23.
//

import UIKit
import SwiftUI

class SeedPhraseTestViewController: UIHostingController<SeedPhraseTestView> {

    let viewModel: SeedPuzzleViewModel
    
    init(viewModel: SeedPuzzleViewModel) {
        self.viewModel = viewModel
        super.init(rootView: SeedPhraseTestView(viewModel: viewModel))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }

}
