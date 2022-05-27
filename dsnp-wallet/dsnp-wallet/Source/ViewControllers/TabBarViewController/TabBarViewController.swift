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
    
    var viewModel = TabBarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        setupTabs()
    }
    
    func set(_ keys: DSNPKeys?) {
        guard let keys = keys else { return }
        let user = OpenUser(keys: keys)
        viewModel.user = user
    }
    
    func setupTabs() {
        let user = viewModel.user
        
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
        homeVC.set(name: user?.name, address: user?.keys?.address)
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let viewController = viewController as? SharedProfileHeaderViewController else { return }
        viewController.set(name: viewModel.user?.name, address: viewModel.user?.keys?.address)
    }
}
