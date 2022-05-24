//
//  SharedButton.swift
//  dsnp-wallet
//
//  Created by Rigo Carbajal on 5/11/21.
//

import UIKit

enum SharedButtonStyle {
    case primary
}

class SharedButton: UIButton {
    private var style: SharedButtonStyle = .primary
    private var storedTitle: String?
    
    init(style: SharedButtonStyle = .primary) {
        super.init(frame: .zero)
        self.style = style
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButton()
    }
    
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 0
        self.contentHorizontalAlignment = .center
        
        if self.style == .primary {
            self.backgroundColor = UIColor.Theme.accentBlue
            self.setTitleColor(UIColor.Theme.background, for: .normal)
            self.tintColor = UIColor.Theme.background
            self.titleLabel?.font = UIFont.Theme.bold(ofSize: 12)
        }
    }

    public func disable() {
        if self.style == .primary {
            self.isEnabled = false
            self.backgroundColor = UIColor.Theme.disabledGray
            self.setTitleColor(.white, for: .normal)
        }
    }
    
    public func enable() {
        if self.style == .primary {
            self.isEnabled = true
            self.backgroundColor = UIColor.Theme.accentBlue
            self.setTitleColor(.white, for: .normal)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.superview?.frame.size.width ?? 0, height: 48)
    }
}
