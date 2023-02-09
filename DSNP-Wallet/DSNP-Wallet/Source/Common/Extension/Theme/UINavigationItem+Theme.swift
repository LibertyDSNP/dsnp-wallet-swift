//
//  UINavigationItem+Theme.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/31/22.
//

import Foundation
import UIKit
import CryptoKit

enum BarButtonSide {
    case left
    case right
}

enum BarButtonItem {
    case logo
    case back
    case settings
    case notifications
    
    var side: BarButtonSide {
        switch self {
        case .settings:
            return .right
        default:
            return .left
        }
    }

    var image: UIImage? {
        switch self {
        case .settings:
            return UIImage(named: "Settings")
        case .back:
            return UIImage(named: "Back")
        default:
            return nil
        }
    }
    
    var tintColor: UIColor {
        switch self {
        default:
            return .white
        }
    }
}

extension UINavigationItem {
    func setBarButton(item: BarButtonItem, target: Any?, selector: Selector?) {
        setBarButton(item: item, target: target, side: item.side, selector: selector)
    }
    
    private func setBarButton(item: BarButtonItem, target: Any?, side: BarButtonSide, selector: Selector?) {
        let barButtonItem = UIBarButtonItem(image: item.image,
                                            style: UIBarButtonItem.Style.plain,
                                            target: target,
                                            action: selector)
        barButtonItem.tintColor = item.tintColor
        
        if side == .left {
            self.leftBarButtonItem = barButtonItem
        } else {
            self.rightBarButtonItem = barButtonItem
        }
    }
    
    func hide(barButtonItem: BarButtonItem) {
        if barButtonItem.side == .left {
            self.leftBarButtonItem = nil
        } else {
            self.rightBarButtonItem = nil
        }
    }
}
