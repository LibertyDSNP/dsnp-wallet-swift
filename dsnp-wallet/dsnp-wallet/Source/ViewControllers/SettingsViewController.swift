//
//  SettingsViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/31/22.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        setViews()
    }
    
    @objc func tappedLogOut(selector: UIButton?) {
        let vc = ViewControllerFactory.generateKeysViewController.instance()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

//MARK: UI Helper
extension SettingsViewController {
    private func setViews() {
        view.backgroundColor = .white
        setBtn()
    }
    
    private func setBtn() {
        let logOutBtn = UIButton(type: .system)
        logOutBtn.setTitle("Log Out", for: .normal)
        logOutBtn.addTarget(self, action: #selector(tappedLogOut(selector:)), for: .touchUpInside)
        logOutBtn.titleLabel?.textColor = .black
        
        view.addSubview(logOutBtn)
        logOutBtn.translatesAutoresizingMaskIntoConstraints = false
        logOutBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
