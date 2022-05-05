//
//  SharedAvatarImageView.swift
//  dsnp-wallet
//
//  Created by Rigo Carbajal on 6/30/21.
//

import UIKit
import SDWebImage

class SharedAvatarImageView: UIImageView {
    
    var hasBorder: Bool = false {
        didSet {
//            self.layer.borderColor = hasBorder ? UIColor.Theme.purple.cgColor : UIColor.clear.cgColor
        }
    }
    
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
//        self.layer.borderWidth = 2
//        self.layer.borderColor = UIColor.Theme.purple.cgColor
        self.contentMode = .scaleAspectFill
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = "SharedAvatarImageView"
//        self.image = UIImage.Theme.noAvatar
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}

extension SharedAvatarImageView {
    func load(_ urlString: String?, completion: (() -> ())? = nil) {
        
        // When used within a reusable view like a cell, it is important to
        // cancel an existing image request, so as not to overwrite with stale data.
        self.sd_cancelCurrentImageLoad()
        
//        self.load(urlString, placeholder: UIImage.Theme.noAvatar, completion: completion)
    }
}
