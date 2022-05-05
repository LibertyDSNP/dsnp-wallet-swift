//
//  ProfileViewController.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/26/22.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: Constants
    private let leadingConstraintConstant = 20
    private let saveBtnBottomOffset = 20
    private let profileText = "Profile"
    private let bioText = "Bio"
    
    //MARK: UI
    private var stackView: UIStackView?
    private var profileHeaderView: ProfileHeaderView?
    private var emailTextfield: UITextField?
    private var bioTextfield: UITextField?
    private let saveBtn = SharedButton()
    private var saveViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: Blocks
    var didEmailChange: Bool = false {
        didSet {
            self.saveBtn.enable()
        }
    }
    var didTogglesChange: Bool = false {
        didSet {
            self.saveBtn.enable()
        }
    }

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.Theme.background
        
        setScrollableStackView()
        
        let profileHeaderView = ProfileHeaderView(parent: self)
        profileHeaderView.delegate = self
        self.profileHeaderView = profileHeaderView
    
        let profileUsernameView = getTextfieldViewWith(titleLabel: profileText, placeholder: "Add Profile Name")
        let bioView = getTextfieldViewWith(titleLabel: bioText, placeholder: "Add Bio")
        let permissionsView = getPermissionsView()
        
        stackView?.addArrangedSubview(profileHeaderView)
        stackView?.addArrangedSubview(SharedSpacer(height: 6))
        stackView?.addArrangedSubview(profileUsernameView)
        stackView?.addArrangedSubview(bioView)
        stackView?.addArrangedSubview(SharedSpacer(height: 3))
        stackView?.addArrangedSubview(permissionsView)
        stackView?.addArrangedSubview(SharedSpacer(height: 40))
        
        setSaveBtn()
        setKeyboard()
    }
}

//MARK: Outlets
extension ProfileViewController {
    @objc func saveChanges(selector: UIButton?) {
        
    }
}

//MARK: UI Helper Funcs
extension ProfileViewController {
    private func setScrollableStackView() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20).isActive = true
        
        let bottomInset = (self.navigationController?.navigationBar.frame.height ?? 0.0) + saveBtn.frame.height + 60
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        
        let embeddedView = UIView()
        scrollView.addSubview(embeddedView)
        embeddedView.layoutAttachAll(to: scrollView.contentLayoutGuide)
        embeddedView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill

        embeddedView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: embeddedView.leadingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: embeddedView.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: embeddedView.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: embeddedView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        self.stackView = stackView
    }
    
    private func getTextfieldViewWith(titleLabel: String, placeholder: String) -> UIView {
        let stackview = UIStackView()
        stackview.distribution = .fill
        stackview.axis = .vertical
        
        let label = getLabel(title: titleLabel)
        let textfield = getTextField(with: placeholder)
        switch titleLabel {
        case profileText:
            self.emailTextfield = textfield
        case bioText:
            self.bioTextfield = textfield
        default:
            return UIView()
        }
        
        let view = UIView()
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(leadingConstraintConstant)).isActive = true
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackview.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        stackview.addArrangedSubview(label)
        stackview.addArrangedSubview(SharedSpacer(height: 8))
        stackview.addArrangedSubview(textfield)
    
        return view
    }
    
    private func getLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.Theme.semibold(ofSize: 15)
        label.textColor = UIColor.Theme.accentBlue
        
        return label
    }
    
    private func getTextField(with placeholder: String) -> UITextField {
        let textfield = UITextField()
        textfield.backgroundColor = .white
        textfield.delegate = self
        textfield.placeholder = placeholder
        textfield.font = UIFont.Theme.regular(ofSize: 12)
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfield.layer.cornerRadius = 4
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height)) //padding
        textfield.leftViewMode = .always
        
        return textfield
    }
    
    private func getPermissionsView() -> UIView {
        let stackview = UIStackView()
        stackview.distribution = .fill
        stackview.axis = .vertical
        stackview.spacing = 10
        
        let permissionsLabel = UILabel()
        permissionsLabel.text = "Permissions"
        permissionsLabel.font = UIFont.Theme.semibold(ofSize: 15)
        permissionsLabel.textColor = UIColor.Theme.accentBlue

        let meweLabel = UILabel()
        meweLabel.text = "MeWe"
        meweLabel.font = UIFont.Theme.bold(ofSize: 12)
        meweLabel.textColor = .white
        
        stackview.addArrangedSubview(permissionsLabel)
        stackview.addArrangedSubview(SharedDivider(color: .gray))
        stackview.addArrangedSubview(SharedSpacer(height: 0.5))
        stackview.addArrangedSubview(meweLabel)
        stackview.addArrangedSubview(SharedSpacer(height: 0.5))
        stackview.addArrangedSubview(SharedDivider(color: .gray))
        
        let view = UIView()
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(leadingConstraintConstant)).isActive = true
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackview.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
        return view
    }
    
    private func setSaveBtn() {
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.titleLabel?.font = UIFont.Theme.regular(ofSize: 12)
        saveBtn.addTarget(self, action: #selector(saveChanges(selector:)), for: .touchUpInside)
        saveBtn.tintColor = UIColor.Theme.accentBlue
        saveBtn.disable()
        
        self.view.addSubview(saveBtn)
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(leadingConstraintConstant)).isActive = true
        saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveViewBottomConstraint = NSLayoutConstraint(item: saveBtn,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: self.view.layoutMarginsGuide,
                                                      attribute: .bottom,
                                                      multiplier: 1,
                                                      constant: CGFloat(-1 * saveBtnBottomOffset))
        saveViewBottomConstraint.isActive = true
    }
    
    private func saveBtn(enabled: Bool) {
        DispatchQueue.main.async {
            self.saveBtn.isEnabled = enabled
//            self.saveBtn.backgroundColor = enabled ? UIColor.Theme.purple : .gray
        }
    }
    
    private func isEdited() -> Bool {
        guard let emailIsEmpty = emailTextfield?.text?.isEmpty else { return false }
        guard let bioIsEmpty = bioTextfield?.text?.isEmpty else { return false }
        
        return !emailIsEmpty || !bioIsEmpty
    }
}

//MARK: Keyboard
extension ProfileViewController {
    private func setKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        keyboardFrame = view.convert(keyboardFrame, from: nil)
        let keyboardHeight = keyboardFrame.height

        //Move Save Btn
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: UIView.AnimationOptions.init(rawValue: curve),
            animations: {
                self.saveViewBottomConstraint.constant = self.view.safeAreaInsets.bottom - keyboardHeight - CGFloat(self.saveBtnBottomOffset)
                self.view.layoutIfNeeded()
            }
        )
    }
    
    @objc private func keyboardWillHide(notification:NSNotification){
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: UIView.AnimationOptions.init(rawValue: curve),
            animations: {
                self.saveViewBottomConstraint.constant = CGFloat(-1 * self.saveBtnBottomOffset)
                self.view.layoutIfNeeded()
            }
        )
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveBtn(enabled: isEdited())
//        guard let text = textField.text else { return }
//        let disable = text.isEmpty || text == self.email
//
//        errorView.isHidden = true
//
//        switch textField.placeholder {
//        case sendVerificationPlaceholder:
//            !disable && DataValidator.isValid(email: textField.text) ? inputBtn.enable() : inputBtn.disable()
//        case verifyPlaceholder:
//            !disable && textField.text?.count == numMaxCharCode ? inputBtn.enable() : inputBtn.disable()
//        default:
//            return
//        }
    }
}

extension ProfileViewController: ProfileHeaderDelegate {
    func tappedAvatar() {
        presentActionSheet()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentActionSheet() {
        self.view.endEditing(true)
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: "Take photo", style: .default) { _ in
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.sourceType = UIImagePickerController.SourceType.camera
            vc.allowsEditing = true
            self.present(vc, animated: true)
        }
                
        let uploadAction = UIAlertAction(title: "Upload photo", style: .default) { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            self.present(vc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        
        actionSheetController.addAction(takeAction)
        actionSheetController.addAction(uploadAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let image = image.downsized(newWidth: 512),
              let profileHeaderView = profileHeaderView else { return }
        profileHeaderView.imageView.image = nil
        //        self.imageUrl = nil
        
        picker.dismiss(animated: true)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        profileHeaderView.imageView.addSubview(activityIndicator)
        activityIndicator.layoutAttachAll(to: profileHeaderView.imageView)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        self.saveBtn(enabled: false)
        
                DispatchQueue.global().async {
        //            TransferManager.shared.uploadAvatar(image: image, didComplete: { url, _ in
        //                DispatchQueue.main.async {
//                            profileHeaderView.set(imageUrl: url)
        //                    activityIndicator.stopAnimating()
        //                    activityIndicator.removeFromSuperview()
                            self.saveBtn(enabled: true)
        //                }
        //            })
                }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
