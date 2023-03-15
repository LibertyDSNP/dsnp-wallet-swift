//
//  SharedLabel.swift
//  UsNative
//
//  Created by Rigo Carbajal on 5/11/21.
//

import UIKit

enum SharedLabelStyle {
    case title
    case subtitle
    case detail
    case body
}

class SharedLabel: UILabel {
    
    var style: SharedLabelStyle = .body
    
    init(style: SharedLabelStyle = .body) {
        super.init(frame: .zero)
        self.style = style
        self.setupView()
        self.updateWithStyle()
    }
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
        self.updateWithStyle()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateWithStyle() {
        
        self.numberOfLines = 0
        
//        switch self.style {
//        case .title:
//            self.font = UIFont.Theme.poppinsBold(ofSize: 24)
//        case .subtitle:
//            self.font = UIFont.Theme.poppinsBold(ofSize: 16)
//        case .detail:
//            self.font = UIFont.Theme.poppinsBold(ofSize: 14)
//        case .body:
//            self.font = UIFont.Theme.poppinsRegular(ofSize: 16)
//        }
        
        self.textColor = .black
    }
}
