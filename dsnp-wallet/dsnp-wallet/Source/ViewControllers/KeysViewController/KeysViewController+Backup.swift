//
//  KeysViewController+Backup.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/26/22.
//

import Foundation
import UIKit

enum BackupKeyMethods: String, CaseIterable {
    case googleDrive = "Google Drive"
    case iCloud = "iCloud"
    case email = "Email"
    case saveToDevice = "Save to device"
}

extension KeysViewController {
    internal func setBackupStackView() {
        stackView.alignment = .center
        stackView.spacing = 10
        
        stackView.addArrangedSubview(SharedSpacer(height: 10))
        stackView.addArrangedSubview(getKeysLabel())
        for backupMethod in BackupKeyMethods.allCases {
            stackView.addArrangedSubview(getBackUpKeyBtn(with: backupMethod.rawValue))
        }
        stackView.addArrangedSubview(SharedSpacer(height: 5))
        stackView.addArrangedSubview(getBackUpKeysLabel())
    }
    
    private func getKeysLabel() -> UIView {
        let label = SharedLabel(text: "Backup")
        label.font = UIFont.Theme.semibold(ofSize: 15)
        label.textAlignment = .center
        
        return label
    }
    
    private func getBackUpKeyBtn(with title: String) -> UIView {
        let btn = SharedButton(style: .primary)
        btn.addTarget(self, action: #selector(tappedBackUpMethod(selector:)), for: .touchUpInside)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.Theme.background, for: .normal)
        btn.titleLabel?.font = UIFont.Theme.regular(ofSize: 12)
        btn.backgroundColor = UIColor.Theme.accentBlue
        
        let view = UIView()
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        btn.heightAnchor.constraint(equalToConstant: CGFloat(33)).isActive = true
        btn.widthAnchor.constraint(equalToConstant: CGFloat(128)).isActive = true
        
        return view
    }
    
    @objc func tappedBackUpMethod(selector: UIButton?) {
        switch selector?.titleLabel?.text {
        case BackupKeyMethods.googleDrive.rawValue:
            viewModel.backupToGoogleDrive()
        default:
            return
        }
    }
    
    private func getBackUpKeysLabel() -> UIView {
        let label = SharedLabel(text: "Backing up your keys is very important dolor sit amet, consectetur adipisicing elit. Qui dicta minus molestiae vel beatae natus eveniet ratione temporibus aperiam harum")
        label.font = UIFont.Theme.regular(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        
        let view = UIView()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        return view
    }
}
