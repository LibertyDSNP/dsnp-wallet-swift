//
//  TestRevokeViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/22/23.
//

import UIKit
import SwiftUI
import Combine

class TestRevokeViewController: UIHostingController<RevokeTestsView> {

    let viewModel: RevokeTestsViewModel
    
    init(viewModel: RevokeTestsViewModel = RevokeTestsViewModel()) {
        self.viewModel = viewModel
        super.init(rootView: RevokeTestsView(viewModel: viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
