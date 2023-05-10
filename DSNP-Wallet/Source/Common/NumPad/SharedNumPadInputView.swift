//
//  SharedNumPadInputView.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/8/21.
//

import UIKit

class SharedNumPadInputView: UIView {
    
    public var didBeginInputSequence: (() -> Void)?
    public var didCompleteSequence: ((SharedNumPadTypeSequence) -> Void)?
    
    private var lastCalculatedWidth: CGFloat?
    
    private var inputItemViews: [SharedNumPadInputItemView] = []
    
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
        
        inputItemViews.removeAll()
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
     
        var lastView: UIView?
        let horizontalPadding: CGFloat = 24
        
        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperView)
        wrapperView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        wrapperView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        for index in 0..<6 {
         
            let itemView = SharedNumPadInputItemView()
            wrapperView.addSubview(itemView)
            itemView.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true
            itemView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
            itemView.heightAnchor.constraint(equalToConstant: itemView.intrinsicContentSize.width).isActive = true
            itemView.widthAnchor.constraint(equalToConstant: itemView.intrinsicContentSize.height).isActive = true
            
            if let view = lastView {
                itemView.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: horizontalPadding).isActive = true
            } else {
                itemView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor).isActive = true
            }
            
            if index == 6 - 1 {
                itemView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor).isActive = true
            }
            
            inputItemViews.append(itemView)
            lastView = itemView
        }
        
        self.lastCalculatedWidth = self.frame.width
    }
    
    public func input(numPadType: SharedNumPadType?) {
        if numPadType == .unknown { return }
        if numPadType == .cancel {
            for view in self.inputItemViews {
                view.numPadTypeInput = nil
            }
        } else if numPadType == .delete {
            for view in self.inputItemViews.reversed() {
                if view.numPadTypeInput != nil {
                    view.numPadTypeInput = nil
                    break
                }
            }
        } else {
            for view in self.inputItemViews {
                if view.numPadTypeInput == nil {
                    view.numPadTypeInput = numPadType
                    if view == self.inputItemViews.first {
                        self.didBeginInputSequence?()
                    }
                    if view == self.inputItemViews.last {
                        self.completeSequence()
                    }
                    
                    break
                }
            }
        }
    }
    
    private func completeSequence() {
        var input: [SharedNumPadType] = []
        for view in self.inputItemViews {
            if let numPadTypeInput = view.numPadTypeInput {
                input.append(numPadTypeInput)
            } else {
                break
            }
        }
        let sequence = SharedNumPadTypeSequence(with: input)
        self.didCompleteSequence?(sequence)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.superview?.frame.size.width ?? 0, height: 0)
    }
}
