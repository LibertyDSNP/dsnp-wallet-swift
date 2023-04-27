//
//  TestViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 10/12/22.
//

import UIKit

enum TestButtons: String, CaseIterable {
    case create = "Create MSA"
    case getMsa = "Get MSA"
    
    case addPublicKeyToMsa = "Add Public Key to MSA"
    case transfer = "Transfer"
}

class TestViewController: ServiceViewController, UITextFieldDelegate {
    //MARK: UI
    private lazy var primaryTextField = getTextField(placeholder: "Primary Mnemomic")
    private lazy var secondaryTextField = getTextField(placeholder: "Secondary Mnemomic")
    
    var extrinsicManager: ExtrinsicManager?
    
    override func viewDidLoad() {
        setViews()
    }
}

extension TestViewController {
    private func setViews() {
        view.backgroundColor = .lightGray
        
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .equalSpacing
        stackview.addArrangedSubview(SharedSpacer(height: 25))
        stackview.addArrangedSubview(primaryTextField)
        stackview.addArrangedSubview(secondaryTextField)
        
        for testButton in TestButtons.allCases {
            let btn = UIButton(type: .system)
            btn.setTitle(testButton.rawValue, for: .normal)
            btn.addTarget(self, action: #selector(tappedBtn(selector:)), for: .touchUpInside)
            btn.titleLabel?.textColor = .black
            btn.contentHorizontalAlignment = .center
            
            stackview.addArrangedSubview(SharedSpacer(height: 4))
            stackview.addArrangedSubview(btn)
        }
        
        stackview.addArrangedSubview(SharedSpacer(height: 25))
        
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.layoutAttachAll(to: view)
    }

    private func getTextField(placeholder: String) -> SharedTextField {
        let textField = SharedTextField(with: placeholder)
        textField.delegate = self
        textField.textAlignment = .center
        
        return textField
    }
    
    @objc func tappedBtn(selector: UIButton?) {
        let completion: ExtrinsicSubmitClosure = { result in
            var text = ""
            
            switch result {
            case .success(let result):
                text = result
                
            case .failure(let error):
                text = "\(error)"
            }
            
            let alert = UIAlertController(title: "Result", message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        let primaryMnemonicInput = primaryTextField.text?.isEmpty ?? true ? "quote grocery buzz staff merit patch outdoor depth eight raw rubber once" : primaryTextField.text ?? ""
        let primaryUser = User(mnemonic: primaryMnemonicInput)
        
        let secondaryMnemonicInput = secondaryTextField.text?.isEmpty ?? true ? "wink settle steak second tuition whale question must honey fossil spider melt" : secondaryTextField.text ?? ""
        let secondaryUser = User(mnemonic: secondaryMnemonicInput)
        
        switch selector?.titleLabel?.text ?? "" {
        case TestButtons.create.rawValue:
            createMsa(user: primaryUser, completion: completion)
        case TestButtons.getMsa.rawValue:
            getMsa(from: primaryUser)
        case TestButtons.addPublicKeyToMsa.rawValue:
            addPublicKeyToMsa(primaryUser: primaryUser,
                              secondaryUser: secondaryUser,
                              completion: completion)
        case TestButtons.transfer.rawValue:
            transfer(primaryUser: primaryUser, secondaryUser: secondaryUser, completion: completion)
        default:
            return
        }
    }
    
    func createMsa(user: User, completion: @escaping ExtrinsicSubmitClosure) {
        let extrinsic: ExtrinsicCalls = .createMsa
        viewModel?.execute(extrinsic: extrinsic, from: user, completion: completion)
    }
    
    func transfer(primaryUser: User, secondaryUser: User, completion: @escaping ExtrinsicSubmitClosure) {
        guard let receiverAddress = secondaryUser.getAddress() else { return }
        let extrinsic: ExtrinsicCalls = .transfer(amount: 1, toAddress: receiverAddress)

        viewModel?.execute(extrinsic: extrinsic, from: primaryUser, completion: completion)
    }
    
    func addPublicKeyToMsa(primaryUser: User, secondaryUser: User, completion: @escaping ExtrinsicSubmitClosure) {
        let extrinsic: ExtrinsicCalls = .addPublicKeyToMsa(primaryUser: primaryUser, secondaryUser: secondaryUser)
    
        viewModel?.execute(extrinsic: extrinsic, from: primaryUser, completion: completion)
    }
    
    func getMsa(from user: User) {
        viewModel?.getMsa(from: user , completion: { msa in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Result", message: "\(msa)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        })
    }
}
