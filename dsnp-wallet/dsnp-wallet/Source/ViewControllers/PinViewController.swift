//
//  PinViewController.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 5/13/22.
//

import Foundation
import UIKit
import DSNPWallet

class PinViewController: UIViewController {
    private var keys: DSNPKeys?
    
    //MARK: Constants
    private lazy var hasAccessPin = AccountKeychain.shared.accessPin != nil
    private lazy var saveBtnText: String = { return hasAccessPin ? "Enter" : "Save" }()
    private let pinLength = 6
    private lazy var pinTextFieldPlaceHolderText = "Enter \(pinLength) digit pin"
    
    //MARK: UI
    private lazy var pinTextField = getPinTextField()
    private lazy var saveBtn = getSaveBtn()
    private lazy var clearPinBtn = getClearPinBtn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
    }
    
    func set(_ keys: DSNPKeys?) {
        self.keys = keys
    }
}

//MARK: UI Helper
extension PinViewController {
    private func setViews() {
        view.backgroundColor = .white
        setPasswordView()
    }
    
    private func setPasswordView() {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.addArrangedSubview(pinTextField)
        stackview.addArrangedSubview(SharedSpacer(height: 4))
        stackview.addArrangedSubview(saveBtn)
        stackview.addArrangedSubview(SharedSpacer(height: 4))
        stackview.addArrangedSubview(clearPinBtn)
        
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func getPinTextField() -> SharedTextField {
        let pinTextField = SharedTextField(with: pinTextFieldPlaceHolderText)
        pinTextField.keyboardType = .numberPad
        pinTextField.delegate = self
        pinTextField.textAlignment = .center
        
        return pinTextField
    }
    
    private func getSaveBtn() -> UIButton {
        let saveBtn = UIButton(type: .system)
        saveBtn.setTitle(saveBtnText, for: .normal)
        saveBtn.addTarget(self, action: #selector(tappedSaveBtn(selector:)), for: .touchUpInside)
        saveBtn.titleLabel?.textColor = .black
        saveBtn.contentHorizontalAlignment = .center
        saveBtn.isEnabled = false

        return saveBtn
    }
    
    @objc func tappedSaveBtn(selector: UIButton?) {
        var alertText = ""
        var pinSuccess = AccountKeychain.shared.accessPin == pinTextField.text
        if hasAccessPin {
            alertText = pinSuccess ? "Signed in" : "Incorrect pin"
        } else {
            AccountKeychain.shared.accessPin = pinTextField.text
            alertText = "Saved pin"
            pinSuccess = true
        }
        
        let alert = UIAlertController(title: alertText, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if !pinSuccess {
                return
            }
            if let tabBarVC = ViewControllerFactory.tabBarViewController.instance() as? TabBarViewController {
                tabBarVC.set(self.keys)
                self.present(tabBarVC, animated: true)
            }
        }))
        present(alert, animated: true)
    }
    
    //TODO: Clear logic strictly for testing purposes.
    private func getClearPinBtn() -> UIButton {
        let clearPinBtn = UIButton(type: .system)
        clearPinBtn.setTitle("Clear Pin", for: .normal)
        clearPinBtn.addTarget(self, action: #selector(tappedClearPinBtn(selector:)), for: .touchUpInside)
        clearPinBtn.titleLabel?.textColor = .black
        clearPinBtn.contentHorizontalAlignment = .center

        return clearPinBtn
    }
    
    @objc func tappedClearPinBtn(selector: UIButton?) {
        AccountKeychain.shared.clearAuthorization()
        saveBtn.setTitle(saveBtnText, for: .normal) 
    }
}

extension PinViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveBtn.isEnabled = textField.text?.count == pinLength
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= pinLength
    }
}
