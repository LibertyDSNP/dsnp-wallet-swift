//
//  EnterPin_SetupPinViewModel.swift
//  UsNative
//
//  Created by Rigo Carbajal on 8/10/21.
//

import UIKit

class EnterPin_SetupPinViewModel: EnterPin_BaseViewModel  {
    
    private var storedPinSequence: SharedNumPadTypeSequence?
    
    override init() {
        super.init()
        self.initialPrompt = "Set Pin Code"
    }
    
    override public func handleDidCompleteSequence(_ sequence: SharedNumPadTypeSequence) {
        if let storedPinSequence = self.storedPinSequence {
            if storedPinSequence == sequence {
                // Pin matches. Save to Keychain.
                AccountKeychain.shared.accessPin = sequence.toString()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.didSucceed?()
                }
            } else {
                // Pin does not match
                self.showConfirmationMessage("Pins Don't Match!", isError: true)
                self.generateIncorrectInputFeedback()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.numPadStackView?.isNumericInputEnabled = true
                    self.numPadStackView?.reset()
                }
            }
            self.storedPinSequence = nil
        } else {
            // Store initial attempt. Ask user to confirm pin.
            self.storedPinSequence = sequence
            self.showConfirmationMessage("Confirm Pin Code")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.numPadStackView?.isNumericInputEnabled = true
                self.numPadStackView?.reset()
            }
        }
    }
}
