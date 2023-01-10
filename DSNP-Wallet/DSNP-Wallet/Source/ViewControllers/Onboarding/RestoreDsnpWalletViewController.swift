//
//  RestoreDsnpIdViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/4/23.
//

import Foundation
import UIKit

class RestoreDsnpIdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupStackView()
    }
    
    //MARK: UI
    func setupStackView() {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        let titleLabel = UILabel()
        titleLabel.text = "Restore DSNP Id"
        stackView.addArrangedSubview(titleLabel)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}
