//
//  SharedNavigationController.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/25/22.
//

import UIKit

class SharedNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(false, animated: false)
    }
    
    private func setNavBar() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            
            navigationController?.navigationBar.tintColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}


