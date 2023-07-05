//
//  SharedNumPadInputItemView.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/8/21.
//

import UIKit

class SharedNumPadInputItemView: UIView {
    
    public var numPadTypeInput: SharedNumPadType? {
        didSet {
            self.isSelected = self.numPadTypeInput != nil
        }
    }
    
    private var isSelected: Bool = false {
        didSet {
            self.backgroundColor = isSelected ? UIColor.purple : .white
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.purple.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 16, height: 16)
    }
}
