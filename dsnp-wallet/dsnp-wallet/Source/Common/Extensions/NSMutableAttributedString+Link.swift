//
//  NSMutableAttributedString+Link.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/4/23.
//

import Foundation

extension NSMutableAttributedString {
   public func setAsLink(textToFind:String, linkURL:String) -> Bool {
       let foundRange = self.mutableString.range(of: textToFind)
       if foundRange.location != NSNotFound {
           self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
           return true
       }
       return false
   }
}
