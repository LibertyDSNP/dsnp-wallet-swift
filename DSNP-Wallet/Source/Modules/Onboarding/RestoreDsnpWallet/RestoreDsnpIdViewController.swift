//
//  RestoreDsnpIdViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/4/23.
//

import Foundation
import UIKit
import DSNPWallet

class RestoreDsnpIdViewController: UIViewController, UITextFieldDelegate {
    
    public var didSucceed:(() -> Void)?
    
    public var viewModel: RestoreDsnpIdViewModel?
    
    private lazy var mnemonicTextField = getTextField(placeholder: "Input mnemomic")

    override func viewDidLoad() {
        setViews()
    }
}

//MARK: UI
extension RestoreDsnpIdViewController {
    private func setViews() {
        view.backgroundColor = .lightGray
        
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.addArrangedSubview(SharedSpacer(height: 25))
        stackview.addArrangedSubview(mnemonicTextField)
        
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        btn.addTarget(self, action: #selector(tappedBtn(selector:)), for: .touchUpInside)
        btn.titleLabel?.textColor = .black
        btn.contentHorizontalAlignment = .center
        
        stackview.addArrangedSubview(SharedSpacer(height: 4))
        stackview.addArrangedSubview(btn)
        
        stackview.addArrangedSubview(SharedSpacer(height: 25))
        
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.layoutAttachAll(to: view)
    }

    private func getTextField(placeholder: String) -> SharedTextField {
        let textField = SharedTextField(with: placeholder)
        textField.delegate = self
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        
        return textField
    }
    
    @objc func tappedBtn(selector: UIButton?) {
        //TODO: Decide how we want to include keys/user through this submit and pass through didSucceed completion block up to TabBarVC?
        if (try? viewModel?.submit(mnemonic: mnemonicTextField.text ?? "")) != nil {
            didSucceed?()
        } else {
            let alert = UIAlertController(title: "Bad mnemonic", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }
}
