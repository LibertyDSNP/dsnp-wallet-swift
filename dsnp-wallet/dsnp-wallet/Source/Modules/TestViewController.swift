//
//  TestViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 10/12/22.
//

import UIKit

class TestViewController: UIViewController, UITextFieldDelegate {
    //MARK: UI
    private lazy var textField = getTextField()
    private lazy var btn = getSaveBtn()
    
    var extrinsicManager: ExtrinsicManager?
    
    override func viewDidLoad() {
        setViews()
    }
}

extension TestViewController {
    private func setViews() {
        view.backgroundColor = .white
        
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.addArrangedSubview(SharedSpacer(height: 25))
        stackview.addArrangedSubview(textField)
        stackview.addArrangedSubview(SharedSpacer(height: 4))
        stackview.addArrangedSubview(btn)
        stackview.addArrangedSubview(SharedSpacer(height: 25))
        
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.layoutAttachAll(to: view)
    }

    private func getTextField() -> SharedTextField {
        let textField = SharedTextField(with: "Mnemonic")
        textField.delegate = self
        textField.textAlignment = .center
        
        return textField
    }
    
    private func getSaveBtn() -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle("Execute", for: .normal)
        btn.addTarget(self, action: #selector(tappedBtn(selector:)), for: .touchUpInside)
        btn.titleLabel?.textColor = .black
        btn.contentHorizontalAlignment = .center

        return btn
    }
    
    @objc func tappedBtn(selector: UIButton?) {
        let mnemonicInput = textField.text?.isEmpty ?? true ? "quote grocery buzz staff merit patch outdoor depth eight raw rubber once" : textField.text ?? ""
        let primaryUser = User(mnemonic: mnemonicInput)
        let secondaryUser = User(mnemonic: "wink settle steak second tuition whale question must honey fossil spider melt")
        
        let completion: ExtrinsicSubmitClosure = { result in
            var text = ""
            
            switch result {
            case .success(let result):
                text = result
                
            case .failure(let error):
                text = "\(error)"
            }
            
            let alert = UIAlertController(title: "Result", message: text, preferredStyle: .alert)
            self.present(alert, animated: true)
        }
        
//        let extrinsic: ExtrinsicCalls = .createMsa
        
//        guard let receiverAddress = secondaryUser.getAddress() else { return }
//        let extrinsic: ExtrinsicCalls = .transfer(amount: 1, toAddress: receiverAddress)
        
        let extrinsic: ExtrinsicCalls = .addPublicKeyToMsa(primaryUser: primaryUser, secondaryUser: secondaryUser)
        
        extrinsicManager = ExtrinsicManager(user: primaryUser)
        extrinsicManager?.execute(extrinsic: extrinsic, completion: completion)
    }
}
