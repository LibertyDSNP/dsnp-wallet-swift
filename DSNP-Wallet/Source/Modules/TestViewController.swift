//
//  TestViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 10/12/22.
//

import UIKit
import SubstrateSdk

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
    private(set) var extrinsicSubscriptionId: UInt16?
    
    override func viewDidLoad() {
        setViews()
    }
    
    deinit {
        cancelExtrinsicSubscriptionIfNeeded()
    }

    private func cancelExtrinsicSubscriptionIfNeeded() {
        if let extrinsicSubscriptionId = extrinsicSubscriptionId,
           let extrinsicService = extrinsicManager?.extrinsicService {
            extrinsicService.cancelExtrinsicWatch(for: extrinsicSubscriptionId)
            self.extrinsicSubscriptionId = nil
        }
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
        let primaryMnemonicInput = primaryTextField.text?.isEmpty ?? true ? "quote grocery buzz staff merit patch outdoor depth eight raw rubber once" : primaryTextField.text ?? ""
        let primaryUser = User(mnemonic: primaryMnemonicInput)
        
        let secondaryMnemonicInput = secondaryTextField.text?.isEmpty ?? true ? "wink settle steak second tuition whale question must honey fossil spider melt" : secondaryTextField.text ?? ""
        let secondaryUser = User(mnemonic: secondaryMnemonicInput)
        let subscriptionIdClosure = getSubscriptionIdClosure()
        let notificationClosure = getSubscriptionNotificationClosure()
        
        switch selector?.titleLabel?.text ?? "" {
        case TestButtons.create.rawValue:
            createMsa(user: primaryUser, subscriptionIdClosure: subscriptionIdClosure, notificationClosure: notificationClosure)
        case TestButtons.getMsa.rawValue:
            getMsa(from: primaryUser)
        case TestButtons.addPublicKeyToMsa.rawValue:
            addPublicKeyToMsa(primaryUser: primaryUser,
                              secondaryUser: secondaryUser,
                              subscriptionIdClosure: subscriptionIdClosure,
                              notificationClosure: notificationClosure)
        case TestButtons.transfer.rawValue:
            transfer(primaryUser: primaryUser,
                     secondaryUser: secondaryUser,
                     subscriptionIdClosure: subscriptionIdClosure,
                     notificationClosure: notificationClosure)
        default:
            return
        }
    }
}

//MARK: Extrinsic Logic
extension TestViewController {
    func createMsa(user: User,
                   subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                   notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) {
        let extrinsic: ExtrinsicCalls = .createMsa
        viewModel?.execute(extrinsic: extrinsic,
                           from: user,
                           subscriptionIdClosure: subscriptionIdClosure,
                           notificationClosure: notificationClosure)
    }
    
    func transfer(primaryUser: User,
                  secondaryUser: User,
                  subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                  notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) {
        guard let receiverAddress = secondaryUser.getAddress() else { return }
        let extrinsic: ExtrinsicCalls = .transfer(amount: 1, toAddress: receiverAddress)

        viewModel?.execute(extrinsic: extrinsic,
                           from: primaryUser,
                           subscriptionIdClosure: subscriptionIdClosure,
                           notificationClosure: notificationClosure)
    }
    
    func addPublicKeyToMsa(primaryUser: User, secondaryUser: User,
                           subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                           notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) {
        let extrinsic: ExtrinsicCalls = .addPublicKeyToMsa(primaryUser: primaryUser, secondaryUser: secondaryUser)
    
        viewModel?.execute(extrinsic: extrinsic, from: primaryUser,
                           subscriptionIdClosure: subscriptionIdClosure,
                           notificationClosure: notificationClosure)
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

//Extrinsic Closure
extension TestViewController {
    func getSubscriptionIdClosure() -> ExtrinsicSubscriptionIdClosure {
        let subscriptionIdClosure: ExtrinsicSubscriptionIdClosure = { [weak self] subscriptionId in
            self?.extrinsicSubscriptionId = subscriptionId
            
            return self != nil
        }
        
        return subscriptionIdClosure
    }
    
    func getSubscriptionNotificationClosure() -> ExtrinsicSubscriptionStatusClosure {
        let notificationClosure: ExtrinsicSubscriptionStatusClosure = { [weak self] result in
            var text = ""
            
            switch result {
            case .success(let status):
                switch status {
                case .finalized(let hash):
                    text = "finalized \(hash)"
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Result", message: text, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                    }
                case .inBlock(let hash):
                    text = "inBlock \(hash)"
                case .finalityTimeout(let hash):
                    text = "finalityTimeout \(hash)"
                case .other:
                    text = "other status"
                }
                self?.cancelExtrinsicSubscriptionIfNeeded()

            case .failure(let error):
                text = "\(error)"
            }
        }
        
        return notificationClosure
    }
}
