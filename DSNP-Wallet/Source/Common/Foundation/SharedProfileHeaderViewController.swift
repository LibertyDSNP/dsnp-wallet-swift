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
    var profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
    }
    
    func set(name: String?, address: String?) {
        profileHeaderView.set(name: name, address: address)
    }
}

//MARK: UI Helper Funcs
extension SharedProfileHeaderViewController {
    private func setViews() {
        self.view.backgroundColor = UIColor.Theme.background
        
        self.navigationItem.setBarButton(item: .settings, target: self, selector: #selector(tappedSettings))
        
        stackView.addArrangedSubview(profileHeaderView)
    }
    
    @objc func tappedSettings() {
        let vc = ViewControllerFactory.settingsViewController.instance()
        self.present(vc, animated: true)
    }
    
    internal func clearStackView() {
        stackView.replaceViews([])
        stackView.addArrangedSubview(profileHeaderView)
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