//
//  SharedLabel.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 5/9/22.
//

import UIKit

class SharedLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.setupView()
        self.updateWithStyle()
    }
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        self.updateWithStyle()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateWithStyle() {
        self.numberOfLines = 0
        self.textColor = .black
        self.font = UIFont.Theme.semibold(ofSize: 15)
        self.textColor = UIColor.Theme.accentBlue
    }
}
