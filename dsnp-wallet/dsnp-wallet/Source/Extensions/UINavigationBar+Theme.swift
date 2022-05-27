//
//  UINavigationBar+Theme.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/26/22.
//

import UIKit

extension UINavigationBar {
    struct Theme {
        static public func backButton() -> UIButton {
            let backButton = UIButton()
            backButton.setImage(UIImage.Theme.backArrow, for: .normal)
            backButton.tintColor = .black
            backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            backButton.contentHorizontalAlignment = .left
            return backButton
        }
    }
}
