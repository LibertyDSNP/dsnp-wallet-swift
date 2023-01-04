//
//  WelcomeViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/4/23.
//

import Foundation
import UIKit
import SafariServices

class WelcomeViewController: UIViewController {
    private enum WelcomeOptions: String {
        case existing = "I have a DSNP ID"
        case create = "Create DSNP ID"
        case restore = "Restore DSNP Wallet"
    }
    
    private var existingBtn: SharedButton?
    private var createBtn: SharedButton?
    private var restoreBtn: SharedButton?
    private var linksTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setBtns()
        setLinksTextView()
        setupStackView()
    }
    
    //MARK: UI
    func setupStackView() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        let titleLabel = UILabel()
        titleLabel.text = "Welcome Screen"
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(SharedSpacer(height: 4))
        
        if let existingBtn = existingBtn {
            stackView.addArrangedSubview(existingBtn)
            stackView.addArrangedSubview(SharedSpacer(height: 4))
        }
        
        if let createBtn = createBtn {
            stackView.addArrangedSubview(createBtn)
            stackView.addArrangedSubview(SharedSpacer(height: 4))
        }
        
        if let restoreBtn = restoreBtn {
            stackView.addArrangedSubview(restoreBtn)
            stackView.addArrangedSubview(SharedSpacer(height: 4))
        }
        
        if let linksTextView = linksTextView {
            stackView.addArrangedSubview(linksTextView)
            stackView.addArrangedSubview(SharedSpacer(height: 4))
        }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setBtns() {
        existingBtn = SharedButton()
        existingBtn?.setTitle(WelcomeOptions.existing.rawValue, for: .normal)
        existingBtn?.addTarget(self, action: #selector(didTapBtn(selector:)), for: .touchUpInside)
        
        createBtn = SharedButton()
        createBtn?.setTitle(WelcomeOptions.create.rawValue, for: .normal)
        createBtn?.addTarget(self, action: #selector(didTapBtn(selector:)), for: .touchUpInside)
        
        restoreBtn = SharedButton()
        restoreBtn?.setTitle(WelcomeOptions.restore.rawValue, for: .normal)
        restoreBtn?.addTarget(self, action: #selector(didTapBtn(selector:)), for: .touchUpInside)
    }
    
    private func setLinksTextView() {
        let attributedString = NSMutableAttributedString(string: "By signing up, you agree to our Terms and Privacy Policy")
        let termsLinkWasSet = attributedString.setAsLink(textToFind: "Terms", linkURL: "https://www.dsnp.org/privacy.html")
        let privacyPolicyLinkWasSet = attributedString.setAsLink(textToFind: "Privacy Policy", linkURL: "https://www.dsnp.org/privacy.html")

        guard termsLinkWasSet && privacyPolicyLinkWasSet else { return }
        linksTextView = UITextView()
        linksTextView?.attributedText = attributedString
    }
    
    //MARK: Outlets
    @objc func didTapBtn(selector: UIButton?) {
        switch selector?.titleLabel?.text {
        case WelcomeOptions.existing.rawValue:
            presentVC(with: .existing)
        case WelcomeOptions.create.rawValue:
            presentVC(with: .create)
        case WelcomeOptions.restore.rawValue:
            presentVC(with: .restore)
        default:
            return
        }
    }
    
    private func presentVC(with welcomeOption: WelcomeOptions) {
        let vc: UIViewController?
        
        switch welcomeOption {
        case .existing:
            vc = ViewControllerFactory.lookUpDsnpIdViewController.instance()
        case .create:
            vc = ViewControllerFactory.createDsnpIdViewController.instance()
        case .restore:
            vc = ViewControllerFactory.restoreDsnpIdViewController.instance()
        }

        guard let vc = vc else { return }
//        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
