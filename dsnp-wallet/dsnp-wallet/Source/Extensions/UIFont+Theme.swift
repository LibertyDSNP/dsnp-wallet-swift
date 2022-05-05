//
//  UIFont+Theme.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 4/27/22.
//

import UIKit

public extension UIFont {
    struct Theme {
        //Heather only wants proxima in this app.
        static public func bold(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "ProximaNova-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func italic(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "ProximaNova-Italic", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func regular(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "ProximaNova-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func semibold(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "ProximaNova-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        static public func thin(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "ProximaNova-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}

