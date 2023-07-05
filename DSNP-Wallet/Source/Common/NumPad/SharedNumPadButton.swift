//
//  SharedNumPadButton.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/1/21.
//

import UIKit

class SharedNumPadButton: UIButton {
    
    public var didPress: ((SharedNumPadType) -> Void)?
    
    public var type: SharedNumPadType?
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = self.isHighlighted ? UIColor.purple : .white
            self.layer.borderColor = self.isHighlighted ? UIColor.purple.cgColor : UIColor(white: 151/255, alpha: 1).cgColor
        }
    }
    
    init(type: SharedNumPadType?) {
        super.init(frame: .zero)
        self.type = type
        self.setupButton()
    }
    
    init() {
        super.init(frame: .zero)
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButton()
    }
    
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.white, for: .highlighted)
        var fontSize: CGFloat
        switch self.type {
        case .cancel:
            fontSize = 14
        case .delete:
            fontSize = 20
        default:
            fontSize = 26
        }
//        self.titleLabel?.font = UIFont.Theme.poppinsRegular(ofSize: fontSize)
        self.setTitle(self.type?.label, for: .normal)
        self.layer.borderWidth = (self.type == .cancel) ? 0 : 1
        self.layer.borderColor = UIColor(white: 151/255, alpha: 1).cgColor
        self.addTarget(self, action: #selector(didPress(sender:)), for: .touchUpInside);
    }
    
    @objc func didPress(sender:UIButton) {
        self.didPress?(self.type ?? .unknown)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 60)
    }
}
