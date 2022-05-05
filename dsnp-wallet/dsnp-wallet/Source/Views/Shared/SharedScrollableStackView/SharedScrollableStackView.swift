//
//  SharedScrollableStackView.swift
//  dsnp-wallet
//
//  Created by Rigo Carbajal on 5/14/21.
//

import UIKit

class SharedScrollableStackView: UIView {
    
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var stackView: SharedStackView?
    
    @IBOutlet private var stackViewTopLayoutConstraint: NSLayoutConstraint?
    @IBOutlet private var stackViewLeadingLayoutConstraint: NSLayoutConstraint?
    @IBOutlet private var stackViewBottomLayoutConstraint: NSLayoutConstraint?

    init(keyboardNotificationsEnabled: Bool? = true) {
        super.init(frame: .zero)
        self.scrollView = self.fromNib()
        self.setupView(keyboardNotificationsEnabled: keyboardNotificationsEnabled)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scrollView = self.fromNib()
        self.setupView()
    }
    
    private func setupView(keyboardNotificationsEnabled: Bool? = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if keyboardNotificationsEnabled ?? true {
            self.registerKeyboardNotifications()
        }
    }
    
    public func replaceViews(_ views: [UIView]?) {
        self.stackView?.replaceViews(views)
    }
    
    public func setStackViewMargins(top: CGFloat, leading: CGFloat, bottom: CGFloat) {
        self.stackViewTopLayoutConstraint?.constant = top
        self.stackViewLeadingLayoutConstraint?.constant = leading
        self.stackViewBottomLayoutConstraint?.constant = bottom
      
        // This allows us to update constraints of stackview subviews.
        // We need to force update on superview, then invalidate
        // constraints on each subview in stack.
        self.layoutIfNeeded()
        for subview in self.stackView?.subviews ?? [] {
            subview.invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: Handle Keyboard Events
    // Allow view to scroll above keyboard when visible
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        DispatchQueue.main.async {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                  let superview = self.superview else { return }
            self.scrollView?.contentInset.bottom = superview.convert(keyboardFrame.cgRectValue, from: nil).size.height - superview.safeAreaInsets.bottom
            self.scrollView?.scrollToBottom(animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.scrollView?.contentInset.bottom = 0
    }
}
