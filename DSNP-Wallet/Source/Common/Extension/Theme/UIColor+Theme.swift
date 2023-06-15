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
        static var textOrange: UIColor { return UIColor(red: 179/255, green: 89/255, blue: 60/255, alpha: 1) }
        static var defaultTextColor: UIColor { return UIColor(red: 35/255, green: 35/255, blue: 48/255, alpha: 1)}
        static var congratsColor: UIColor { return UIColor(red: 5/255, green: 48/255, blue: 49/255, alpha: 1)}
        static var buttonOrange: UIColor { return UIColor(red: 218/255, green: 94/255, blue: 58/255, alpha: 1)}
        static var buttonGray: UIColor { return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)}
        static var termsTextColor: UIColor { return UIColor(red: 47/255, green: 52/255, blue: 55/255, alpha: 1)}
        static var errorStringColor: UIColor { return UIColor(red: 251/255, green: 11/255, blue: 11/255, alpha: 1)}
        static var progressBarGray: UIColor { return UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)}
        static var seeAllYellow: UIColor { return UIColor(red: 215/255, green: 182/255, blue: 99/255, alpha: 1)}
        static var freqBackground: UIColor { return UIColor(red: 25/255, green: 26/255, blue: 27/255, alpha: 1)}
        static var editButtonTeal: UIColor { return UIColor(red: 1/255, green: 122/255, blue: 134/255, alpha: 1) }

        static var toDoBackground: UIColor { return UIColor(red: 251/255, green: 231/255, blue: 204/255, alpha: 1) }
        static var toDoButtonText: UIColor { return UIColor(red: 203/255, green: 101/255, blue: 69/255, alpha: 1) }
        static var listItemBackground: UIColor { return UIColor(red: 143/255, green: 230/255, blue: 210/255, alpha: 1) }
        static var errorListItemForegroundColor: UIColor { return UIColor(red: 115/255, green: 131/255, blue: 133/255, alpha: 1) }
    }
}

