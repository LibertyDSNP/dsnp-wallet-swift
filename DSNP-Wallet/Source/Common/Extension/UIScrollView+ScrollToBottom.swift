//
//  UIScrollView+ScrollToBottom.swift
//  UsNative
//
//  Created by Rigo Carbajal on 5/10/21.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.height + self.contentInset.bottom)
        if bottomOffset.y > 0 {
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }
}
