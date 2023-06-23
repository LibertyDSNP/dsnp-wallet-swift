//
//  SharedNumPadGridView.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/1/21.
//

import UIKit

class SharedNumPadTypeSequence: Equatable {
    
    public var sequence: [SharedNumPadType]?
    
    init(with sequence: [SharedNumPadType]?) {
        self.sequence = sequence
    }
    
    public func toString() -> String? {
        var string = ""
        for sequenceItem in self.sequence ?? [] {
            string += sequenceItem.label ?? ""
        }
        return string.isEmpty ? nil : string
    }
    
    static func == (lhs: SharedNumPadTypeSequence, rhs: SharedNumPadTypeSequence) -> Bool {
        return lhs.sequence == rhs.sequence
    }
}

enum SharedNumPadType {

    case unknown
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case cancel
    case delete
    
    public var label: String? {
        switch self {
        case .zero:
            return "0"
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .cancel:
            return "Cancel"
        case .delete:
            return "﹤"
        default:
            return nil
        }
    }
}

class SharedNumPadGridView: UIView {
    
    public var didPressNumPadItem: ((SharedNumPadType) -> Void)?
    
    public var isNumericInputEnabled: Bool = true {
        didSet {
            self.updateNumericInputEnabledState()
        }
    }
    
    private var lastCalculatedWidth: CGFloat?
    
    private var numPadButtons: [SharedNumPadButton] = []
    private let numPadItemRows: [[SharedNumPadType]] = [
        [.one, .two, .three],
        [.four, .five, .six],
        [.seven, .eight, .nine],
        [.cancel, .zero, .delete]
    ]
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure we only layout subviews once per new width
        if self.lastCalculatedWidth == self.frame.width { return }
        
        self.numPadButtons.removeAll()
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let horizontalPadding: CGFloat = 20
        let verticalPadding: CGFloat = 15
        var currentTopAnchor: NSLayoutAnchor = self.topAnchor
        var lastNumPadButton: SharedNumPadButton?
        
        for (index, numPadItemRow) in self.numPadItemRows.enumerated() {
            
            let rowView = UIView()
            rowView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(rowView)
            rowView.topAnchor.constraint(equalTo: currentTopAnchor, constant: currentTopAnchor == self.topAnchor ? 0 : verticalPadding).isActive = true
            currentTopAnchor = rowView.bottomAnchor
            rowView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            if index == self.numPadItemRows.count - 1 {
                // If last element, anchor to bottom of view in order to establish grid height.
                rowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            }
            
            for (index, numPadItem) in numPadItemRow.enumerated() {
                
                let numPadButton = SharedNumPadButton(type: numPadItem)
                numPadButton.didPress = { type in
                    self.didPressNumPadItem?(type)
                }
                
                rowView.addSubview(numPadButton)
                let numPadButtonSize = numPadButton.intrinsicContentSize
                numPadButton.heightAnchor.constraint(equalToConstant: numPadButtonSize.height).isActive = true
                numPadButton.widthAnchor.constraint(equalToConstant: numPadButtonSize.width).isActive = true
                numPadButton.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
                numPadButton.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true
                
                if let lastNumPadButton = lastNumPadButton {
                    numPadButton.leadingAnchor.constraint(equalTo: lastNumPadButton.trailingAnchor, constant: horizontalPadding).isActive = true
                } else {
                    numPadButton.leadingAnchor.constraint(equalTo: rowView.leadingAnchor).isActive = true
                }
                
                if index == numPadItemRow.count - 1 {
                    numPadButton.trailingAnchor.constraint(equalTo: rowView.trailingAnchor).isActive = true
                }
                
                self.numPadButtons.append(numPadButton)
                lastNumPadButton = numPadButton
            }
            
            self.updateNumericInputEnabledState()
            lastNumPadButton = nil
        }
        
        self.lastCalculatedWidth = self.frame.width
    }
    
    private func updateNumericInputEnabledState() {
        // Even when input is disabled, we always want
        // user to be able to cancel out of view.
        for numPadButton in self.numPadButtons {
            if numPadButton.type != .cancel {
                numPadButton.isUserInteractionEnabled = self.isNumericInputEnabled
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.superview?.frame.size.width ?? 0, height: 0)
    }
}
