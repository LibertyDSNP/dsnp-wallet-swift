//
//  UIButton+Theme.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/31/22.
//

import Foundation
import UIKit

extension UIButton {
    struct Theme {
        static var back: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "Back"), for: .normal)
            button.tintColor = .white
            return button
            
        }()
        static var settings: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "Settings"), for: .normal)
            button.tintColor = .white
            return button
        }()
        static var notifications: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "Settings"), for: .normal)
            button.tintColor = .white
            return button
        }()
    }
}
