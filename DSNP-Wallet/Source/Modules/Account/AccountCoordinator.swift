//
//  AccountCoordinator.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/8/21.
//

import UIKit

class AccountCoordinator {
    public static let shared = AccountCoordinator()
    public lazy var navigationController: SharedNavigationController? = {
        return SharedNavigationController(rootViewController: self.startingViewController())
    }()
    
    private func startingViewController() -> UIViewController {
        return getWelcomeViewController()
    }
    
    public func logout() {
        try? AuthManager.shared.logout()
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                self.navigationController?.viewControllers = [self.startingViewController()]
                window.rootViewController = self.navigationController
                window.makeKeyAndVisible()
            }
        }
    }
}

//MARK: Navigation
extension AccountCoordinator {
    public func navigateToTabBarViewController() {
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                let vc = ViewControllerFactory.tabBarViewController.instance()
                vc.modalPresentationStyle = .fullScreen
                
                window.rootViewController?.present(vc, animated: true)
            }
        }
    }
    
    public func navigateToEnterPinViewController() {
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                if let navigationController = window.rootViewController as? SharedNavigationController,
                   !(navigationController.viewControllers.first is BaseViewController) {
                    window.rootViewController = self.getEnterPinViewController()
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    public func navigateToSeedPhraseViewController() {
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                guard let vc = ViewControllerFactory.seedPhraseViewController.instance() as? SeedPhraseViewController else { return }
                vc.modalPresentationStyle = .fullScreen
                vc.didSucceed = {
                    self.navigateToTabBarViewController()
                }
                
                window.rootViewController?.present(vc, animated: true)
            }
        }
    }
}

//MARK: ViewControllers
extension AccountCoordinator {
    private func getWelcomeViewController() -> UIViewController {
        let vc = ViewControllerFactory.welcomeViewController.instance() as! WelcomeViewController
        vc.navToLookupDsnpId = {}
        
        vc.navToCreateDsnpId = {
            self.navigateToEnterPinViewController()
        }
        
        vc.navToRestoreDsnpId = {}
        
        return vc
    }
    
    private func getEnterPinViewController() -> UIViewController {
        let enterPinViewController = ViewControllerFactory.enterPinViewController.instance() as! EnterPinViewController
        enterPinViewController.didSucceed = {
            self.navigateToSeedPhraseViewController() //TODO: STRICTLY FOR TESTING, UNCOMMENT BELOW
            
            //            if let _ = AuthManager.shared.loadKeys() {
            //            self.navigateTo(vc: .tabbar)
            //            } else {
            //                self.navigateToSeedPhraseViewController()
            //            }
        }
        
        enterPinViewController.didCancel = {}
        return enterPinViewController
    }
}
