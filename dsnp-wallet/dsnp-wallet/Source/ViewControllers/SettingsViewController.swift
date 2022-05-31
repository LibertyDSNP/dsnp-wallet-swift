//
//  SettingsViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/31/22.
//

import Foundation
import UIKit
import DSNPWallet

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        setViews()
    }
    
    @objc func tappedLogOut(selector: UIButton?) {
        do {
            let _ = try DSNPWallet().deleteKeys()
        } catch {
            let alert = UIAlertController(title: "Error deleting keys", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        AccountKeychain.shared.clearAuthorization()
        
        present(getCancelAlert(), animated: true, completion: nil)
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
    
    private func getCancelAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Logging out will clear your keys.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let vc = ViewControllerFactory.generateKeysViewController.instance()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        return alert
    }
}
