//
//  UIViewController+FromString.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/25/22.
//

import UIKit

extension UIViewController {
    
    class func fromString(viewControllerName: String?) -> UIViewController? {
        guard let viewControllerName = viewControllerName else { return nil }
        if let viewControllerType = NSClassFromString("DSNP_Wallet.\(viewControllerName)") as? UIViewController.Type {
            return viewControllerType.init()
        }

        return nil
    }
}

