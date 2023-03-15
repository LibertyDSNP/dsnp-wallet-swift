//
//  StartupSequenceViewController.swift
//  UsNative
//
//  Created by Rigo Carbajal on 11/18/21.
//

import UIKit
import Apollo

class StartupSequenceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigateToAccountCoordinator()
    }
    
    private func navigateToAccountCoordinator() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController =  AccountCoordinator.shared.navigationController
            }
        }
    }
}
