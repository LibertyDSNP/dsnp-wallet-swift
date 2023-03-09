//
//  EnterPin_ValidatePinViewModel.swift
//  UsNative
//
//  Created by Rigo Carbajal on 8/10/21.
//

import UIKit

class EnterPin_ValidatePinViewModel: EnterPin_BaseViewModel  {
    
    override init() {
        super.init()
        self.initialPrompt = "Enter Pin Code"
    }
    
    override public func handleDidCompleteSequence(_ sequence: SharedNumPadTypeSequence) {
        if sequence.toString() == "1111" {//AccountKeychain.shared.accessPin {
            // Pin matches
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.didSucceed?()
            }
        } else {
            // Pin does not match
            self.showConfirmationMessage("Incorrect Pin Entered", isError: true)
            self.generateIncorrectInputFeedback()
            self.lockoutViewModel?.incrementUnlockAttempt()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if !(self.lockoutViewModel?.isLockedOut ?? false) {
                    self.numPadStackView?.isNumericInputEnabled = true
                }
                self.numPadStackView?.reset()
            }
        }
    }
}
