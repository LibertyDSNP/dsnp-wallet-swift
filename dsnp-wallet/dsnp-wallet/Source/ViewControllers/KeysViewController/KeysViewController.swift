//
//  KeysViewController.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/26/22.
//

import Foundation
import UIKit

enum KeysViewControllerState {
    case keys
    case backupKeys
}

class KeysViewController: SharedProfileHeaderViewController {
    internal var viewModel = KeysViewModel()
    internal var state: KeysViewControllerState = .keys {
        didSet {
            manageStateViews()
        }
    }
    
    //TODO: Remove after api connected
    var keys: [Key] = [Key(isRoot: true, title: "rootKey", address: "0x0123456789") ,
                       Key(title: "iPhone", address: "0x0123456789"),
                       Key(title: "Macbook", address: "0x0123456789"),
                       Key(title: "iMac", address: "0x0123456789")]
    var connectKeyBtns: [SharedButton] = []
    
    //MARK: Constants
    private let leadingConstraintConstant = 25
    private let connectDevicesBtnBottomOffset = 20
    
    //MARK: UI
    private let connectDeviceBtn = SharedButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = .keys
    }
}

//MARK: UI Helper Funcs
extension KeysViewController {
    internal func setBackBtn(hide: Bool = false) {
        let backButton = UINavigationBar.Theme.backButton()
        backButton.tintColor = .white
        backButton.addAction(UIAction { _ in
            self.state = .keys
        }, for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        backButton.isHidden = hide
    }
    
    private func manageStateViews() {
        clearStackView()
        
        setBackBtn(hide: state == .keys)
        
        switch state {
        case .keys:
            setKeysStackView()
        case .backupKeys:
            setBackupStackView()
        }
        
        connectDeviceBtn.isHidden = state != .keys
    }
    
    private func setKeysStackView() {
        stackView.alignment = .fill
        stackView.spacing = 0
        
        stackView.addArrangedSubview(SharedSpacer(height: 20))
        stackView.addArrangedSubview(getKeysLabel())
        stackView.addArrangedSubview(SharedSpacer(height: 5))
        stackView.addArrangedSubview(getRootKey())
        for keyView in getKeyViews() {
            stackView.addArrangedSubview(keyView)
        }
        
        setConnectDeviceBtn()
    }
    
    private func getKeysLabel() -> UIView {
        let view = UIView()
        let myKeysLabel = SharedLabel(text: "My Keys")
        myKeysLabel.font = UIFont.Theme.semibold(ofSize: 15)
        myKeysLabel.textColor = UIColor.Theme.accentBlue
        
        view.addSubview(myKeysLabel)
        myKeysLabel.translatesAutoresizingMaskIntoConstraints = false
        myKeysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(leadingConstraintConstant)).isActive = true
        myKeysLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myKeysLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myKeysLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }
    
    private func getRootKey() -> UIView {
        return getKeyView(isRootKey: true, title: "Root Key", address: keys.first?.condensedAddress ?? "")
    }
    
    private func getKeyViews() -> [UIView] {
        var views: [UIView] = []
        
        for key in keys {
            if key.isRoot { continue }
            
            views.append(getKeyView(title: key.title ?? "", address: key.condensedAddress))
        }
        
        return views
    }
    
    private func getKeyView(isRootKey: Bool = false, title: String, address: String) -> UIView {
        let view = UIView()
        
        let titleLabel = SharedLabel(text: title)
        titleLabel.font = UIFont.Theme.semibold(ofSize: 10)
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: isRootKey ? CGFloat(leadingConstraintConstant) : CGFloat(leadingConstraintConstant) + 50).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let addressLabel = SharedLabel(text: address)
        addressLabel.font = UIFont.Theme.thin(ofSize: 10)
        addressLabel.textColor = .white
        view.addSubview(addressLabel)
        addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 35).isActive = true
        addressLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let btn = isRootKey ? getBackUpRootKeyBtn() : getConnectKeyBtn()
        
        let btnWidth = 35
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: CGFloat(isRootKey ? 80 : btnWidth)).isActive = true
        btn.heightAnchor.constraint(equalToConstant: CGFloat(btnWidth)).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1 * CGFloat(leadingConstraintConstant)).isActive = true
        
        return view
    }
    
    private func getBackUpRootKeyBtn() -> SharedButton {
        let btn = SharedButton(style: .primary)
        btn.addTarget(self, action: #selector(tappedBackUpRootKeyBtn(selector:)), for: .touchUpInside)
        btn.setTitle("Backup", for: .normal)
        btn.setTitleColor(UIColor.Theme.background, for: .normal)
        btn.titleLabel?.font = UIFont.Theme.regular(ofSize: 12)
        btn.backgroundColor = UIColor.Theme.accentBlue
        
        return btn
    }
    
    private func getConnectKeyBtn() -> SharedButton {
        let btn = SharedButton(style: .primary)
        btn.addTarget(self, action: #selector(tappedConnectKeyBtn(selector:)), for: .touchUpInside)

        updateConnectKeyBtn(btn: btn, isSelected: btn.isSelected)
        connectKeyBtns.append(btn)
        
        return btn
    }
    
    private func setConnectDeviceBtn() {
        connectDeviceBtn.setTitle("Connect Device", for: .normal)
        connectDeviceBtn.titleLabel?.font = UIFont.Theme.regular(ofSize: 12)
        connectDeviceBtn.addTarget(self, action: #selector(tappedConnectDeviceBtn(selector:)), for: .touchUpInside)
        
        self.view.addSubview(connectDeviceBtn)
        connectDeviceBtn.translatesAutoresizingMaskIntoConstraints = false
        connectDeviceBtn.widthAnchor.constraint(equalToConstant: 160).isActive = true
        connectDeviceBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectDeviceBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30).isActive = true
        
        let bottomInset = (self.navigationController?.navigationBar.frame.height ?? 0.0) + connectDeviceBtn.frame.height + 60
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
}

//MARK: Outlets
extension KeysViewController {
    @objc func tappedBackUpRootKeyBtn(selector: UIButton?) {
        state = .backupKeys
    }
    
    @objc func tappedConnectKeyBtn(selector: UIButton?) {
        for btn in connectKeyBtns {
            guard btn == selector else { continue }
            
            btn.isSelected = !btn.isSelected
            updateConnectKeyBtn(btn: btn, isSelected: btn.isSelected)
        }
    }
    
    private func updateConnectKeyBtn(btn: SharedButton, isSelected: Bool) {
        let connectBtnImg = isSelected ? UIImage(named: "Lock") : UIImage(named: "Unlock")
        btn.setImage(connectBtnImg, for: .normal)
        btn.backgroundColor = btn.isSelected ? UIColor.Theme.accentBlue : UIColor.Theme.disabledGray
    }
    
    @objc func tappedConnectDeviceBtn(selector: UIButton?) {
        
    }
}
