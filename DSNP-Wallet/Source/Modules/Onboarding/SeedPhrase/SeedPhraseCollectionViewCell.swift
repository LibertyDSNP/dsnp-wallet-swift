//
//  SeedPhraseCollectionViewCell.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/10/23.
//

import Foundation
import UIKit

class SeedPhraseCollectionViewCell: UICollectionViewCell {
    static let cellId = "SeedPhraseCollectionViewCell"

    private var stackView = UIStackView()
    private var numberLabel = {
        let label = UILabel()
        label.font = UIFont.Theme.spaceRegular(ofSize: 12)
        return label
    }()
    
    private var wordLabel = {
        let label = UILabel()
        label.font = UIFont.Theme.spaceRegular(ofSize: 12)
        return label
    }()
    
    private let bgColor: UIColor = UIColor.Theme.buttonOrange
    var isDeselected: Bool = false {
        didSet {
            contentView.backgroundColor = isDeselected ? .clear : bgColor
        }
    }
    
    var number: Int? {
        didSet {
            if let number = number {
                stackView.insertArrangedSubview(numberLabel, at: 0)
                numberLabel.text = String(number + 1)
            }
        }
    }
    
    var word: String? {
        didSet {
            wordLabel.text = word ?? ""
        }
    }
    
    private func setupAccessibilityIds() {
        accessibilityIdentifier = "resultCell"
        accessibilityElements = [numberLabel as Any, wordLabel as Any]
        numberLabel.accessibilityIdentifier = "cellNumber"
        wordLabel.accessibilityIdentifier = "cellValue"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAccessibilityIds()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        contentView.backgroundColor = bgColor
        
        wordLabel.textAlignment = .center
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        if let _ = numberLabel.text {
            stackView.addArrangedSubview(numberLabel)
        }
        
        stackView.addArrangedSubview(wordLabel)
    
        contentView.addSubview(stackView)
        stackView.layoutAttachAll(to: contentView)
    }
}
