//
//  TestViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 10/12/22.
//

import UIKit
import SubstrateSdk
import RobinHood

enum TestButtons: String, CaseIterable {
    case create = "Create MSA"
    case getMsa = "Get MSA"
    
    case addPublicKeyToMsa = "Add Public Key to MSA"
    case transfer = "Transfer"
}

class TestViewController: ServiceViewController, UITextFieldDelegate {
    private lazy var primaryTextField = getTextField(placeholder: "Primary Mnemomic")
    private lazy var secondaryTextField = getTextField(placeholder: "Secondary Mnemomic")
    
    override func viewDidLoad() {
        viewModel?.txHandlerDelegate = self
        
        setViews()
    }
    
    deinit {
        viewModel?.cancelExtrinsicSubscriptionIfNeeded()
    }
}

//MARK: UI
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
        
        //Closures
        let subscriptionIdClosure = getSubscriptionIdClosure()
        let notificationClosure = getSubscriptionNotificationClosure(completion: { items in
            guard let item = items.first else { return }
            
            let processingResult = item.processingResult
            let resultTitle = item.processingResult.isSuccess ? "Extrinsic Succeeded" : "Extrinsic Failed"
            DispatchQueue.main.async {
                let alert = UIAlertController(title: resultTitle, message: "\(processingResult)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        })
        
        switch selector?.titleLabel?.text ?? "" {
        case TestButtons.create.rawValue:
            createMsa(primaryUser: primaryUser, subscriptionIdClosure: subscriptionIdClosure, notificationClosure: notificationClosure)
        case TestButtons.getMsa.rawValue:
            getMsa(primaryUser: primaryUser)
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
    func createMsa(primaryUser: User,
                   subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                   notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) {
        let extrinsic: ExtrinsicCalls = .createMsa
        viewModel?.execute(extrinsic: extrinsic,
                           from: primaryUser,
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
    
    func addPublicKeyToMsa(primaryUser: User,
                           secondaryUser: User,
                           subscriptionIdClosure: @escaping ExtrinsicSubscriptionIdClosure,
                           notificationClosure: @escaping ExtrinsicSubscriptionStatusClosure) {
        let extrinsic: ExtrinsicCalls = .addPublicKeyToMsa(primaryUser: primaryUser, secondaryUser: secondaryUser)
    
        viewModel?.execute(extrinsic: extrinsic,
                           from: primaryUser,
                           subscriptionIdClosure: subscriptionIdClosure,
                           notificationClosure: notificationClosure)
    }
}

//MARK: StorageQuery {
extension TestViewController {
    func getMsa(primaryUser: User) {
        viewModel?.getMsa(from: primaryUser, completion: { msa in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Result", message: "\(msa)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        })
    }
}

//MARK: Extrinsic Closure
extension TestViewController {
    func getSubscriptionIdClosure() -> ExtrinsicSubscriptionIdClosure {
        let subscriptionIdClosure: ExtrinsicSubscriptionIdClosure = { [weak self] subscriptionId in
            self?.viewModel?.extrinsicSubscriptionId = subscriptionId
            
            return self != nil
        }
        
        return subscriptionIdClosure
    }
    
    func getSubscriptionNotificationClosure(completion: @escaping TransactionSubscriptionCompletion) -> ExtrinsicSubscriptionStatusClosure {
        let notificationClosure: ExtrinsicSubscriptionStatusClosure = { [weak self] result in
            var text = ""
            
            switch result {
            case .success(let status):
                switch status {
                case .finalized(let hash):
                    text = "finalized \(hash)"
                    
                    self?.process(blockHash: hash, completion: completion)
                case .inBlock(let hash):
                    text = "inBlock \(hash)"
                case .finalityTimeout(let hash):
                    text = "finalityTimeout \(hash)"
                case .other:
                    text = "other status"
                }
                
                self?.viewModel?.cancelExtrinsicSubscriptionIfNeeded()

            case .failure(let error):
                text = "\(error)"
            }
        }
        
        return notificationClosure
    }
}

//MARK: Subscription
extension TestViewController {
    private func process(blockHash: String, completion: @escaping TransactionSubscriptionCompletion) {
        let primaryMnemonicInput = primaryTextField.text?.isEmpty ?? true ? "quote grocery buzz staff merit patch outdoor depth eight raw rubber once" : primaryTextField.text ?? ""
        let primaryUser = User(mnemonic: primaryMnemonicInput)
        
        guard
            let blockHash = try? Data(hexString: blockHash)
        else { return }
        
        viewModel?.process(from: primaryUser,
                           blockhash: blockHash,
                           completion: completion)
    }
}

extension TestViewController: TransactionHandlerDelegate {
    func handleTransactions(result: Result<[RobinHood.DataProviderChange<TransactionHistoryItem>], Error>) {
        switch result {
        case .success(let items):
            print(items)
        case .failure(let error):
            print(error)
        }
    }
}
