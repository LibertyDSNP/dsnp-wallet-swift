//
//  SharedAvatarImageView.swift
//  dsnp-wallet
//
//  Created by Rigo Carbajal on 6/30/21.
//

import UIKit
import SDWebImage

class SharedAvatarImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = "SharedAvatarImageView"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
