//
//  SharedNumPadStackView.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/9/21.
//

import UIKit

class SharedNumPadStackView: SharedStackView {
    
    public var didBeginInputSequence: (() -> Void)?
    public var didCompleteSequence: ((SharedNumPadTypeSequence) -> Void)?
    public var didCancel: (() -> Void)?
    
    private var numPadInputView: SharedNumPadInputView?
    private var numPadGridView: SharedNumPadGridView?
    
    public var isNumericInputEnabled: Bool = true {
        didSet {
            self.numPadGridView?.isNumericInputEnabled = self.isNumericInputEnabled
        }
    }
    
    override init() {
        super.init()
        self.setupSubviews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupSubviews()
    }
    
    private func setupSubviews() {
        self.axis = .vertical
        
        let numPadInputView = SharedNumPadInputView()
        numPadInputView.didBeginInputSequence = { [weak self] in
            guard let self = self else { return }
            self.didBeginInputSequence?()
        }
        numPadInputView.didCompleteSequence = { [weak self] sequence in
            guard let self = self else { return }
            self.didCompleteSequence?(sequence)
        }
        self.addArrangedSubview(numPadInputView)
        self.numPadInputView = numPadInputView
        
        self.addArrangedSubview(SharedSpacer(height: 40))
        
        let numPad = SharedNumPadGridView()
        numPad.didPressNumPadItem = { [weak self] type in
            guard let self = self else { return }
            if type == .cancel {
                self.didCancel?()
            } else {
                self.numPadInputView?.input(numPadType: type)
            }
        }
        self.addArrangedSubview(numPad)
        self.numPadGridView = numPad
    }
    
    public func reset() {
        self.numPadInputView?.input(numPadType: .cancel)
    }
}
