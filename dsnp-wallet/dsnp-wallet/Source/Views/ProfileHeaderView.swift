//
//  ProfileHeaderView.swift
//  dsnp-wallet
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
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Jane_Wynter" //TODO: Hook up with API
        label.font = UIFont.Theme.semibold(ofSize: 21)
        label.textColor = UIColor.Theme.accentBlue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var userAddressLabel: UILabel = {
        var label = UILabel()
        label.text = "ADDRESS" //TODO: Hook up with API
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
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: parent?.view.frame.width ?? 0,
                      height: parent?.view.frame.width ?? 0)
    }
}

//MARK: UI Helper Func
extension ProfileHeaderView {
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

//MARK: Outlets
extension ProfileHeaderView {
    @objc func pressButton(selector: UIButton?) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
//            guard let self = self else { return }
//            self.contentPicker?.openCamera()
//        }))
//        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
//            guard let self = self else { return }
//            self.contentPicker?.openGallery()
//        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.parent?.present(alert, animated: true, completion: nil)
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

//extension ProfileHeaderView: ContentPickerDelegate {
//    func didSelect() {//)contentAttachments: [LocalContentAttachment]?, error: Error?) {
//        DispatchQueue.main.async {
//            if let image = contentAttachments?.first?.previewImage,
//               let image = image.downsized(newWidth: 512) {
//                self.imageView?.image = image
//                self.didSelectImage?(image)
//            }
//        }
//    }
//}
