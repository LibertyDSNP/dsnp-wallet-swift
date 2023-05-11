//
//  AccountCoordinator.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/8/21.
//

import UIKit
import IrohaCrypto

class AccountCoordinator {
    public static let shared = AccountCoordinator()
    public lazy var navigationController: SharedNavigationController? = {
        return SharedNavigationController(rootViewController: self.startingVc())
    }()
    
    private func startingVc() -> UIViewController {
        if let _ = try? AccountKeychain.shared.fetchKey(),
           let mnemonic = AccountKeychain.shared.getMnemonic() {
            let user = User(mnemonic: mnemonic)
            return getEnterPinVc(user: user)
        } else {
            return getWelcomeVc()
        }
    }
    
    public func logout() {
        try? AccountKeychain.shared.clearAuthorization()
        
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                self.navigationController?.viewControllers = [self.getWelcomeVc()]
                window.rootViewController = self.navigationController
                window.makeKeyAndVisible()
            }
        }
    }
}

//MARK: Navigation
extension AccountCoordinator {
    //Presents tabbar as new window, not part of onboarding navigation controller flow
    public func navigateToTabBarVc(user: User) {
        DispatchQueue.main.async {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                if let navigationController = window.rootViewController as? SharedNavigationController,
                   !(navigationController.viewControllers.first is BaseViewController) {
                    guard let vc = ViewControllerFactory.tabBarViewController.instance() as? TabBarViewController else { return }
                    vc.viewModel = TabBarViewModel()
                    vc.viewModel.user = user
                    
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    //Part of onboarding nav bar flow
    private func navigateToSeedPhraseVc(didSucceed: @escaping (User)->()) {
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
    private func getWelcomeVc() -> UIViewController {
        let vc = ViewControllerFactory.welcomeViewController.instance() as! WelcomeViewController
        vc.navToLookupDsnpId = {}
        
        vc.navToCreateDsnpId = {
            self.navigateToSeedPhraseVc(didSucceed: { user in
                self.navigateToTabBarVc(user: user)
            })
        }
        
        vc.navToRestoreDsnpId = {
            let restoreVc = self.getRestoreDsnpIdVc(didSucceed: { user in
                self.navigateToTabBarVc(user: user)
            })
            
            self.navigationController?.pushViewController(restoreVc, animated: true)
        }
        
        return vc
    }
    
    private func getEnterPinVc(user: User) -> UIViewController {
        let enterPinViewController = ViewControllerFactory.enterPinViewController.instance() as! EnterPinViewController
        enterPinViewController.didSucceed = {
            self.navigateToTabBarVc(user: user)
        }
        enterPinViewController.didCancel = {}
        
        return enterPinViewController
    }
    
    private func getRestoreDsnpIdVc(didSucceed: @escaping (User)->()) -> UIViewController {
        let vc = ViewControllerFactory.restoreDsnpIdViewController.instance() as! RestoreDsnpIdViewController
        vc.viewModel = RestoreDsnpIdViewModel()
        vc.didSucceed = didSucceed
        
        return vc
    }
}

class RestoreDsnpIdViewModel {
    func submit(mnemonic: String) throws -> IRCryptoKeypairProtocol?  {
        if let keypair = SeedManager.shared.getKeypair(mnemonic: mnemonic) {
            try? AccountKeychain.shared.save(mnemonic: mnemonic)
            return keypair
        } else {
            return nil
        }
    }
}
