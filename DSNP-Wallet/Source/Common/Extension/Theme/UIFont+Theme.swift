//
//  UIFont+Theme.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 4/27/22.
//

import UIKit

public extension UIFont {
    struct Theme {
        static public func bold(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func italic(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-Italic", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func regular(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func semibold(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func extraBold(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-ExtraBold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func thin(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func medium(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "Poppins-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}

