//
//  GenerateKeysViewController.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 5/11/22.
//

import UIKit
import DSNPWallet

class GenerateKeysViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        manageKeys()
    }
    
    private func manageKeys() {
        do {
            if let keys = try DSNPWallet().loadKeys() {
                DispatchQueue.main.async { [weak self] in
                    self?.presentPinVC(with: keys)
                }
            }
        } catch {
            setBtn()
            
            let alert = UIAlertController(title: "Error loading keys", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
    }
    
    @objc func generateNewKeys(selector: UIButton?) {
        do {
            if let keys = try DSNPWallet().createKeys() {
                self.presentPinVC(with: keys)
            }
        } catch {
            let alert = UIAlertController(title: "Error Creating New Keys", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: UI Helper
extension GenerateKeysViewController {
    private func setBtn() {
        let genKeysBtn = UIButton(type: .system)
        genKeysBtn.setTitle("New Keys", for: .normal)
        genKeysBtn.addTarget(self, action: #selector(generateNewKeys(selector:)), for: .touchUpInside)
        genKeysBtn.titleLabel?.textColor = .black
        
        view.addSubview(genKeysBtn)
        genKeysBtn.translatesAutoresizingMaskIntoConstraints = false
        genKeysBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        genKeysBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func presentPinVC(with keys: DSNPKeys?) {
        guard let pinVC = ViewControllerFactory.pinViewController.instance() as? PinViewController else { return }
        
        pinVC.set(keys)
        pinVC.modalPresentationStyle = .fullScreen
        self.present(pinVC, animated: true)
    }
}
