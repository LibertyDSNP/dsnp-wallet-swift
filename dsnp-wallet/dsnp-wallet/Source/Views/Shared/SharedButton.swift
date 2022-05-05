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
    private lazy var activityIndicatorView: UIActivityIndicatorView? = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .white
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isUserInteractionEnabled = false
        activityIndicatorView.startAnimating()
        self.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()
    
    public var text: String? {
        return self.title(for: .normal) ?? self.attributedTitle(for: .normal)?.string
    }
    
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
        
//        if self.style == .link {
//            self.contentHorizontalAlignment = .left
//        } else {
            self.contentHorizontalAlignment = .center
//        }
        
        if self.style == .primary {
            self.backgroundColor = UIColor.Theme.accentBlue
            self.setTitleColor(.white, for: .normal)
            self.titleLabel?.font = UIFont.Theme.bold(ofSize: 12)
        }
    }
    
    public func setTitle(_ title: String?) {
        self.storedTitle = title
        self.updateTitle(self.storedTitle, for: .normal)
    }
    
    private func updateTitle(_ title: String?, for state: UIControl.State = .normal) {
        self.setTitle(title, for: state)
    }
    
    public func setFont(_ font: UIFont) {
        self.titleLabel?.font = font
    }
    
    public func setTitleColor(_ color: UIColor) {
        self.titleLabel?.textColor = color
    }
    
    public func disable() {
        if self.style == .primary {
            self.isEnabled = false
            self.backgroundColor = UIColor(red: 171/255, green: 172/255, blue: 171/255, alpha: 1)
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
    
    public func displayLoadingState() {
        self.isEnabled = false
        self.updateTitle(nil)
        self.activityIndicatorView?.isHidden = false
    }
    
    public func hideLoadingState() {
        self.isEnabled = true
        self.updateTitle(self.storedTitle)
        self.activityIndicatorView?.isHidden = true
    }
    
    override var intrinsicContentSize: CGSize {
//        if self.style == .link {
//            return CGSize(width: self.superview?.frame.size.width ?? 0, height: 30)
//        } else {
            return CGSize(width: self.superview?.frame.size.width ?? 0, height: 48)
//        }
    }
}
