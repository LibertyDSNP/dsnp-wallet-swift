//
//  ProfileHeaderView.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 4/27/22.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func tappedAvatar()
}

class ProfileHeaderView: UIView {
    public weak var delegate: ProfileHeaderDelegate?
    public var didSelectImage: ((UIImage?) -> Void)?
    
    private var parent: UIViewController?
    
    //MARK: Constants
    let imageViewWidth: CGFloat = 185.0
    
    lazy private var stackView: SharedStackView = {
        let stackView = SharedStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
    
    private var smartIdLabel: UILabel = {
        var label = UILabel()
        label.text = "Smart ID"
        label.font = UIFont.Theme.semibold(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    //Exposed in ProfileViewController for PhotoSelection
    var imageView: SharedAvatarImageView = {
        var imageView = SharedAvatarImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.Theme.semibold(ofSize: 21)
        label.textColor = UIColor.Theme.accentBlue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var userAddressLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.Theme.thin(ofSize: 9)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    init(parent: UIViewController?) {
        super.init(frame: .zero)
        self.parent = parent
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.Theme.profileHeaderViewBackground

        setBottomCornerRadius()
        setStackView()
        addGestureRecognizers()
    }
}

//MARK: Public Setters
extension ProfileHeaderView {
    func set(_ image: UIImage) {
        self.imageView.image = image
    }
    
    func set(name: String?, address: String?) {
        userNameLabel.text = name
        userAddressLabel.text = address
    }
}

//MARK: UI Helper Func
extension ProfileHeaderView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: parent?.view.frame.width ?? 0,
                      height: parent?.view.frame.width ?? 0)
    }
    
    private func setBottomCornerRadius() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 17
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    private func setStackView() {
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let imageSubview = UIView()
        imageSubview.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        imageView.centerXAnchor.constraint(equalTo: imageSubview.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageSubview.heightAnchor).isActive = true
        
        stackView.replaceViews([SharedSpacer(height: 30),
                                smartIdLabel,
                                SharedSpacer(height: 12),
                                imageSubview,
                                SharedSpacer(height: 10),
                                userNameLabel,
                                SharedSpacer(height: 10),
                                userAddressLabel,
                                SharedSpacer(height: 24)
                               ])
    }
}


//MARK: Photo Selection
extension ProfileHeaderView {
    private func addGestureRecognizers() {
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(tappedAvatar(tap:)))
        imageView.addGestureRecognizer(avatarTap)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func tappedAvatar(tap: UITapGestureRecognizer) {
        delegate?.tappedAvatar()
    }
}
