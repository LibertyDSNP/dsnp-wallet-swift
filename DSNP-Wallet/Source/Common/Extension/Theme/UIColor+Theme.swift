//
//  UIColor+Theme.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 4/26/22.
//


import UIKit

extension UIColor {
    struct Theme {
        static var profileHeaderViewBackground: UIColor { return UIColor(red: 35/255, green: 35/255, blue: 48/255, alpha: 0.72) }
        static var background: UIColor { return UIColor(red: 59/255, green: 63/255, blue: 81/255, alpha: 1) }
        static var accentBlue: UIColor { return UIColor(red: 82/255, green: 225/255, blue: 197/255, alpha: 1) }
        static var accentOrange: UIColor { return UIColor(red: 255/255, green: 99/255, blue: 61/255, alpha: 1) }
        static var disabledGray: UIColor { return UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1) }
        
        // New UI
        static var primaryTeal: UIColor { return UIColor(red: 27/255, green: 158/255, blue: 163/255, alpha: 1) }
        static var disabledTeal: UIColor { return UIColor(red: 179/255, green: 211/255, blue: 220/255, alpha: 1) }
        static var bgGray: UIColor { return UIColor(red: 228/255, green: 229/255, blue: 229/255, alpha: 1) }
        static var bgTeal: UIColor { return UIColor(red: 5/255, green: 48/255, blue: 49/255, alpha: 1) }
        static var linkOrange: UIColor { return UIColor(red: 218/255, green: 94/255, blue: 58/255, alpha: 1) }
        static var defaultTextColor: UIColor { return UIColor(red: 35/255, green: 35/255, blue: 48/255, alpha: 1)}
    }
}

