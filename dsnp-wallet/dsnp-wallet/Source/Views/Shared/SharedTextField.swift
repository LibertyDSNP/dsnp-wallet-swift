//
//  SharedTextField.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 5/9/22.
//

import UIKit

class SharedTextField: UITextField {
    
    var includePadding = false {
        didSet {
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height)) //padding
            self.leftViewMode = .always
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.setupView()
        self.updateWithStyle()
    }
    
    convenience init(with placeholder: String) {
        self.init()
        self.placeholder = placeholder
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
        self.backgroundColor = .white
        self.placeholder = placeholder
        self.font = UIFont.Theme.regular(ofSize: 12)
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = 4
    }
}
