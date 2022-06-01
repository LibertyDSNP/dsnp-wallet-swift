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
        let alert = UIAlertController(title: "Logging out will clear your keys.", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            do {
                let _ = try AuthManager.shared.logout()
            } catch {
                let alert = UIAlertController(title: "Problem deleting keys, log out failed.", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            self.presentGenKeysVC()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
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
    
    private func presentGenKeysVC() {
        let vc = ViewControllerFactory.generateKeysViewController.instance()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
