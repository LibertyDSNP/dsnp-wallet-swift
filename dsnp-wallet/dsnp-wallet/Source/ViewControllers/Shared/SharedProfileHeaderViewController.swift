//
//  SharedProfileHeaderViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/10/22.
//

import UIKit

class SharedProfileHeaderViewController: UIViewController {
    //MARK: UI
    lazy var stackView: SharedStackView = getScrollableStackView()
    var scrollView = UIScrollView()
    var profileHeaderView: ProfileHeaderView?
    var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBar()
        setViews()
    }
    
    func set(name: String?, address: String?) {
        profileHeaderView?.set(name: name, address: address)
    }
}

//MARK: UI Helper Funcs
extension SharedProfileHeaderViewController {
    private func setNavBar() {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            
            navigationController?.navigationBar.tintColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func setViews() {
        self.view.backgroundColor = UIColor.Theme.background
        
        let profileHeaderView = ProfileHeaderView(parent: self)
        self.profileHeaderView = profileHeaderView
        
        stackView.addArrangedSubview(profileHeaderView)
    }
    
    internal func clearStackView() {
        stackView.replaceViews([])
        guard let view = profileHeaderView else { return }
        stackView.addArrangedSubview(view)
    }
    
    private func getScrollableStackView() -> SharedStackView {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollViewBottomConstraint = NSLayoutConstraint(item: scrollView,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: self.view.layoutMarginsGuide,
                                                        attribute: .bottom,
                                                        multiplier: 1,
                                                        constant: 0)
        scrollViewBottomConstraint.isActive = true
        
        let embeddedView = UIView()
        scrollView.addSubview(embeddedView)
        embeddedView.layoutAttachAll(to: scrollView.contentLayoutGuide)
        embeddedView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        let stackView = SharedStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        embeddedView.addSubview(stackView)
        stackView.layoutAttachAll(to: embeddedView)
        
        return stackView
    }
}
