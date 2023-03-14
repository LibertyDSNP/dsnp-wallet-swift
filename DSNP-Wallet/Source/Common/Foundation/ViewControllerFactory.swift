//
//  ViewControllerFactory.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/25/22.
//

import Foundation
import UIKit

enum ViewControllerFactory: String, CaseIterable {
    
    case enterPinViewController
    case tabBarViewController
    case homeViewController
    case profileViewController
    case keysViewController
    case settingsViewController
    case welcomeViewController
    case lookUpDsnpIdViewController //Potentially deprecate
    case createDsnpIdViewController //Potentially deprecate
    case restoreDsnpIdViewController
    case seedPhraseViewController
    case testViewController
    
    var className: String {
        return self.rawValue.firstUppercased
    }
    
    var storyboardName: String? {
        switch self {
        case .homeViewController,
                .profileViewController,
                .keysViewController,
                .enterPinViewController,
                .settingsViewController,
                .welcomeViewController,
                .lookUpDsnpIdViewController,
                .createDsnpIdViewController,
                .restoreDsnpIdViewController,
                .seedPhraseViewController,
                .testViewController:
            return nil
        default:
            return self.rawValue.firstUppercased
        }
    }
    
    func instance() -> UIViewController {
        var vc: UIViewController?
        if let storyboardName = self.storyboardName {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            vc = storyboard.instantiateInitialViewController()
        } else {
            vc = UIViewController.fromString(viewControllerName: self.className)
        }

        if let serviceVc = vc as? ServiceViewController {
            serviceVc.viewModel = ServiceViewModel()
            return serviceVc
        }
        
        return vc ?? UIViewController()
    }
}

