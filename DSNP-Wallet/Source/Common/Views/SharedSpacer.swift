//
//  SharedSpacer.swift
//  desp-wallet
//
//  Created by Rigo Carbajal on 5/11/21.
//

import UIKit

class SharedSpacer: UIView {
    
    private var height: CGFloat = 0
    
    init(height: CGFloat) {
        super.init(frame: .zero)
        self.height = height
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.size.width, height: self.height)
    }
}
