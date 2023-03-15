//
//  LookUpDsnpIdViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/4/23.
//

import Foundation
import UIKit

class LookUpDsnpIdViewController: UIViewController {
    
    private enum LookUpDsnpIdOptions: String {
        case sendAuth = "Send Auth Code"
        case restore = "Restore DSNP Wallet"
    }
    
    private var segmentedControl: UISegmentedControl?
    private var textField: UITextField?
    private var sendBtn: UIButton?
    private var restoreBtn: UIButton?
    private var linksTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSegmentedControl()
        setupTextField()
        setupBtns()
        setupLinksTextView()
        setupStackView()
        setupGestureRecognizer()
    }
    
    //MARK: UI
    func setupStackView() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        let titleLabel = UILabel()
        titleLabel.text = "Look Up DSNP ID"
        stackView.addArrangedSubview(titleLabel)
        
        if let segmentedControl = segmentedControl {
            stackView.addArrangedSubview(segmentedControl)
            stackView.addArrangedSubview(SharedSpacer(height: 4))
        }
        
        if let textField = textField {
            stackView.addArrangedSubview(textField)
            stackView.addArrangedSubview(SharedSpacer(height: 4))
        }
        
        if let sendBtn = sendBtn {
            stackView.addArrangedSubview(sendBtn)
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
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["Email", "Phone"])
        segmentedControl?.selectedSegmentIndex = 0
        segmentedControl?.addTarget(self, action: #selector(self.segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    private func setupTextField() {
        textField = UITextField()
        textField?.delegate = self
        
        guard let textField = textField else { return }
        
        let view = UIView()
        view.addSubview(textField)
        textField.layoutAttachAll(to: view)
        
        updateTextField()
    }
    
    private func updateTextField() {
        guard let segmentedControl = segmentedControl,
              let textField = textField else { return }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            textField.placeholder = "name@email.com"
            textField.keyboardType = .emailAddress
        } else if segmentedControl.selectedSegmentIndex == 1 {
            textField.placeholder = "Phone Number"
            textField.keyboardType = .phonePad
        } else {
            return
        }
    }
    
    private func setupBtns() {
        sendBtn = SharedButton()
        sendBtn?.setTitle(LookUpDsnpIdOptions.sendAuth.rawValue, for: .normal)
        sendBtn?.addTarget(self, action: #selector(didTapBtn(selector:)), for: .touchUpInside)
        
        restoreBtn = SharedButton()
        restoreBtn?.setTitle(LookUpDsnpIdOptions.restore.rawValue, for: .normal)
        restoreBtn?.addTarget(self, action: #selector(didTapBtn(selector:)), for: .touchUpInside)
    }
    
    private func setupLinksTextView() {
        let attributedString = NSMutableAttributedString(string: "By signing up, you agree to our Terms and Privacy Policy")
        let termsLinkWasSet = attributedString.setAsLink(textToFind: "Terms", linkURL: "https://www.dsnp.org/privacy.html")
        let privacyPolicyLinkWasSet = attributedString.setAsLink(textToFind: "Privacy Policy", linkURL: "https://www.dsnp.org/privacy.html")

        guard termsLinkWasSet && privacyPolicyLinkWasSet else { return }
        linksTextView = UITextView()
        linksTextView?.attributedText = attributedString
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Outlets
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        textField?.resignFirstResponder()
        updateTextField()
        textField?.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textField?.resignFirstResponder()
    }

    @objc func didTapBtn(selector: UIButton?) {
        switch selector?.titleLabel?.text {
        case LookUpDsnpIdOptions.sendAuth.rawValue:
            print("Send Auth Code")
        case LookUpDsnpIdOptions.restore.rawValue:
            presentVC(with: .restore)
        default:
            return
        }
    }
    
    private func presentVC(with options: LookUpDsnpIdOptions) {
        let vc: UIViewController?
        
        switch options {
        case .restore:
            vc = ViewControllerFactory.restoreDsnpIdViewController.instance()
        default:
            return
        }

        guard let vc = vc else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
 }

extension LookUpDsnpIdViewController: UITextFieldDelegate {}
