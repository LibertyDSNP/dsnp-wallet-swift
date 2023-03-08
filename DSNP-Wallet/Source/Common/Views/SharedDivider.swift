//
//  SharedDivider.swift
//  DSNP-Wallet
//
//  Created by Rigo Carbajal on 5/11/21.
//

import UIKit

class SharedDivider: UIView {
    
    private var height: CGFloat = 1
    var isHorizontal: Bool = true
    
    init(height: CGFloat = 1) {
        super.init(frame: .zero)
        self.height = height
        
        self.setupView()
    }
    convenience init(height: CGFloat = 1, color: UIColor) {
        self.init(height: height)
        
        self.setupView(bgColor: color)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView(bgColor: UIColor = .black) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = bgColor
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: isHorizontal ? self.superview?.frame.size.width ?? 0 : self.height,
                      height: isHorizontal ? self.height : self.superview?.frame.size.height ?? 0)
    }
}
