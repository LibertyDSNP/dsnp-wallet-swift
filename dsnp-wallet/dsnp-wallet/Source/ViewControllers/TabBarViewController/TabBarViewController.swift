//
//  TabBarViewController.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/25/22.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    private var navVC: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    func setupTabs() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        self.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        }
        
        //Global Back Btn Config
        UINavigationBar.appearance().backIndicatorImage = UIImage.Theme.backArrow
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage.Theme.backArrow
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        UINavigationBar.appearance().backItem?.backButtonTitle = ""
 
        let homeVC = ViewControllerFactory.homeViewController.instance()
        let homeIcon = UITabBarItem(title: "Home", image: UIImage(named: "Home"), selectedImage: UIImage(named: "Home"))
        homeIcon.accessibilityIdentifier = "homeTabBarButton"
        homeVC.tabBarItem = homeIcon
        
        let profileVC = ViewControllerFactory.profileViewController.instance()
        let profileIcon = UITabBarItem(title: "Profile", image: UIImage(named: "Profile"), selectedImage: UIImage(named: "Profile"))
        profileIcon.accessibilityIdentifier = "profileIconTabBarButton"
        profileVC.tabBarItem = profileIcon
        
        let keysVC = ViewControllerFactory.keysViewController.instance()
        let keysIcon = UITabBarItem(title: "Keys", image: UIImage(named: "Keys"), selectedImage: UIImage(named: "Keys"))
        keysIcon.accessibilityIdentifier = "keysTabBarButton"
        keysVC.tabBarItem = keysIcon


        self.viewControllers? = [homeVC, profileVC, keysVC]
    }
}
