//
//  TabBarViewController.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/25/22.
//

import Foundation
import UIKit
import DSNPWallet

class TabBarViewController: UITabBarController {
    var viewModel = TabBarViewModel(user: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
}

//MARK: UI
extension TabBarViewController {
    func setupTabs() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.Theme.accentOrange
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        }
 
        guard let homeVC = ViewControllerFactory.homeViewController.instance() as? SharedProfileHeaderViewController else { return }
        let navHomeVC = SharedNavigationController(rootViewController: homeVC)
        let homeIcon = UITabBarItem(title: "Home", image: UIImage(named: "Home"), selectedImage: UIImage(named: "Home"))
        homeIcon.accessibilityIdentifier = "homeTabBarButton"
        navHomeVC.tabBarItem = homeIcon
        
        guard let profileVC = ViewControllerFactory.profileViewController.instance() as? ProfileViewController else { return }
        let navProfileVC = SharedNavigationController(rootViewController: profileVC)
        let profileIcon = UITabBarItem(title: "Profile", image: UIImage(named: "Profile"), selectedImage: UIImage(named: "Profile"))
        profileIcon.accessibilityIdentifier = "profileIconTabBarButton"
        navProfileVC.tabBarItem = profileIcon
        profileVC.updateUserBlock = viewModel.updateUserBlock
        
        let keysVC = ViewControllerFactory.keysViewController.instance()
        let navKeysVC = SharedNavigationController(rootViewController: keysVC)
        let keysIcon = UITabBarItem(title: "Keys", image: UIImage(named: "Keys"), selectedImage: UIImage(named: "Keys"))
        keysIcon.accessibilityIdentifier = "keysTabBarButton"
        navKeysVC.tabBarItem = keysIcon

        self.viewControllers? = [navHomeVC, navProfileVC, navKeysVC]
        
        updateViewControllers(with: viewModel.user)
    }

    private func updateViewControllers(with user: User?) {
        guard let address = try? user?.getAddress() else {
            return
        }
        
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let navVc = viewController as? SharedNavigationController,
                   let vc = navVc.topViewController as? SharedProfileHeaderViewController {
                    vc.set(name: user?.name, address: address)
                }
            }
        }
    }
    
    public func navigateToProfile() {
        //TODO: Deeplinking to different parts of the app
    }
}
