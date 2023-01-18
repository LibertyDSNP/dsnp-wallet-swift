//
//  SharedStackView.swift
//  DSNP-Wallet
//
//  Created by Rigo Carbajal on 5/18/21.
//

import UIKit

class SharedStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func replaceViews(_ views: [UIView]?) {
        self.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        for view in views ?? [] {
            self.addArrangedSubview(view)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.superview?.frame.size.width ?? 0, height: 0)
    }
}
