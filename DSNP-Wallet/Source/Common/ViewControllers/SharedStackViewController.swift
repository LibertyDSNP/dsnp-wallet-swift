//
//  SharedStackViewController.swift
//  UsNative
//
//  Created by Rigo Carbajal on 5/14/21.
//

import UIKit

class SharedStackViewController: UIViewController {
    
    public var scrollableStackView: SharedScrollableStackView?
    public var backButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let scrollableStackView = SharedScrollableStackView()
        self.view.addSubview(scrollableStackView)
        scrollableStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollableStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollableStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollableStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.scrollableStackView = scrollableStackView
        
        let backButton = UIButton()
        backButton.setImage(UIImage.Theme.backArrow, for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.addTarget(self, action: #selector(backButtonPressed(selector:)), for: .touchUpInside)
        self.backButton = backButton
    }
    
    @objc public func backButtonPressed(selector: UIButton?) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
