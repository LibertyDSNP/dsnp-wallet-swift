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
        return SharedNavigationController(rootViewController: self.startingVc())
    }()
    
    private func startingVc() -> UIViewController {
        let vc = ViewControllerFactory.welcomeViewController.instance() as! WelcomeViewController
        vc.navToLookupDsnpId = {}
        
        //MARK: Update this flow to present pin screen on second load ticket #92
        vc.navToCreateDsnpId = {
            self.navigationController?.pushViewController(self.getEnterPinVc(didSucceed: {
//                if let keys = AuthManager.shared.loadKeys() {
//                    self.navigateToTabBarVc()
//                } else {
                    self.navigateToSeedPhraseVc(didSucceed: { self.navigateToTabBarVc() })
//                }
            }), animated: true)
        }
        
        vc.navToRestoreDsnpId = {
            self.navigationController?.pushViewController(self.getRestoreDsnpIdVc(didSucceed: { self.navigateToTabBarVc() }), animated: true)
        }
        
        return vc
    }
    
    public func logout() {
        try? AuthManager.shared.logout()
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                self.navigationController?.viewControllers = [self.startingVc()]
                window.rootViewController = self.navigationController
                window.makeKeyAndVisible()
            }
        }
    }
}

//MARK: Navigation
extension AccountCoordinator {
    //Presents tabbar as new window, not part of onboarding navigation controller flow
    public func navigateToTabBarVc() {
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                let vc = ViewControllerFactory.tabBarViewController.instance()
                vc.modalPresentationStyle = .fullScreen
                
                window.rootViewController?.present(vc, animated: true)
            }
        }
    }
    
    //Part of onboarding nav bar flow
    private func navigateToSeedPhraseVc(didSucceed: @escaping ()->()) {
        DispatchQueue.main.async {
            guard let seedPhraseVc = ViewControllerFactory.seedPhraseViewController.instance() as? SeedPhraseViewController else { return }
            seedPhraseVc.modalPresentationStyle = .fullScreen
            seedPhraseVc.didSucceed = didSucceed
            
            self.navigationController?.pushViewController(seedPhraseVc, animated: true)
        }
    }
}

//MARK: ViewControllers
extension AccountCoordinator {
    private func getEnterPinVc(didSucceed: @escaping ()->()) -> UIViewController {
        let enterPinViewController = ViewControllerFactory.enterPinViewController.instance() as! EnterPinViewController
        enterPinViewController.didSucceed = didSucceed
        enterPinViewController.didCancel = {}
        
        return enterPinViewController
    }
    
    private func getRestoreDsnpIdVc(didSucceed: @escaping ()->()) -> UIViewController {
        let vc = ViewControllerFactory.restoreDsnpIdViewController.instance() as! RestoreDsnpIdViewController
        vc.viewModel = RestoreDsnpIdViewModel()
        vc.didSucceed = didSucceed
        
        return vc
    }
}
