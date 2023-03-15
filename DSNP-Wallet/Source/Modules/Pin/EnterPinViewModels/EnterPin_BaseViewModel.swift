//
//  EnterPin_BaseViewModel.swift
//  UsNative
//
//  Created by Rigo Carbajal on 5/27/21.
//

import UIKit

class EnterPin_BaseViewModel: NSObject  {
    
    public var didSucceed: (() -> Void)?
    public var didCancel: (() -> Void)?
    
    public var initialPrompt: String? = "Enter Pin Code"
    public var promptLabel: UILabel?
    private var confirmationLabel: SharedLabel?
    public var numPadStackView: SharedNumPadStackView?
    public lazy var lockoutViewModel: EnterPin_LockoutViewModel? = {
        let lockoutViewModel = EnterPin_LockoutViewModel()
        lockoutViewModel.lock = {
            self.lockInput()
        }
        lockoutViewModel.unlock = {
            self.unlockInput()
        }
        return lockoutViewModel
    }()
    
    public func stackViews() -> [UIView] {
        
        var views: [UIView] = []
        
//        views.append(SharedLogoView(type: .compact))
//        
//        views.append(SharedSpacer(height: 25))
//        
//        views.append(LockImageView())
//        
//        views.append(SharedSpacer(height: 10))
        
        let promptLabel = SharedLabel(style: .subtitle)
        promptLabel.text = self.initialPrompt
        views.append(promptLabel)
        self.promptLabel = promptLabel
        
        views.append(SharedSpacer(height: 5))
        
        let confirmationWrapperView = UIView()
        confirmationWrapperView.translatesAutoresizingMaskIntoConstraints = false
        let confirmationLabel = SharedLabel(style: .body)
//        confirmationLabel.font = UIFont.Theme.poppinsRegular(ofSize: 14)
        confirmationLabel.isHidden = true
        confirmationWrapperView.addSubview(confirmationLabel)
        confirmationWrapperView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        views.append(confirmationWrapperView)
        self.confirmationLabel = confirmationLabel
        
        views.append(SharedSpacer(height: 5))
        
        views.append(SharedDivider())
        
        views.append(SharedSpacer(height: 30))
        
        let numPadStackView = SharedNumPadStackView()
        numPadStackView.didBeginInputSequence = {
            self.hideConfirmationMessage()
        }
        numPadStackView.didCompleteSequence = { [weak self] sequence in
            guard let self = self else { return }
            self.numPadStackView?.isNumericInputEnabled = false
            self.handleDidCompleteSequence(sequence)
        }
        numPadStackView.didCancel = { [weak self] in
            guard let self = self else { return }
            self.didCancel?()
        }
        views.append(numPadStackView)
        self.numPadStackView = numPadStackView
        
        self.lockoutViewModel?.updateState()
        
        return views
    }
    
    public func handleDidCompleteSequence(_ sequence: SharedNumPadTypeSequence) {}
    
    public func generateIncorrectInputFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    private func lockInput() {
        self.numPadStackView?.isNumericInputEnabled = false
        self.showConfirmationMessage("Account locked for 10 minutes", isError: true)
    }
    
    private func unlockInput() {
        self.numPadStackView?.isNumericInputEnabled = true
        self.hideConfirmationMessage()
    }
    
    public func showConfirmationMessage(_ message: String?, isError: Bool = false) {
        self.confirmationLabel?.text = message
        self.confirmationLabel?.textColor = isError ? .red : .black
        self.confirmationLabel?.isHidden = false
    }
    
    private func hideConfirmationMessage() {
        self.confirmationLabel?.isHidden = true
    }
}
