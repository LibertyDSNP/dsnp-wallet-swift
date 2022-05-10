//
//  ProfileViewController.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/26/22.
//

import UIKit

class ProfileViewController: SharedProfileHeaderViewController {
    //MARK: Constants
    private let leadingConstraintConstant = 20
    private let saveBtnBottomOffset = 20
    private let profileText = "Profile"
    private let bioText = "Bio"
    
    //MARK: UI
    private var emailTextfield: UITextField?
    private var bioTextfield: UITextField?
    private let saveBtn = SharedButton()
    private var saveViewBottomConstraint: NSLayoutConstraint!
    
    private var imagePicker: SharedImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileHeaderView?.delegate = self
        
        setViews()
        setImagePicker()
    }
    
    private func setImagePicker() {
        imagePicker = SharedImagePicker(parent: self)
        imagePicker?.delegate = self
    }
}

//MARK: Outlets
extension ProfileViewController {
    @objc func saveChanges(selector: UIButton?) {
        
    }
}

//MARK: UI Helper Funcs
extension ProfileViewController {
    private func setViews() {
        let profileUsernameView = getTextfieldViewWith(titleLabel: profileText, placeholder: "Add Profile Name")
        let bioView = getTextfieldViewWith(titleLabel: bioText, placeholder: "Add Bio")
        let permissionsView = getPermissionsView()
        
        stackView.addArrangedSubview(SharedSpacer(height: 6))
        stackView.addArrangedSubview(profileUsernameView)
        stackView.addArrangedSubview(bioView)
        stackView.addArrangedSubview(SharedSpacer(height: 3))
        stackView.addArrangedSubview(permissionsView)
        
        setSaveBtn()
        setKeyboard()
    }
    
    private func getTextfieldViewWith(titleLabel: String, placeholder: String) -> UIView {
        let stackview = UIStackView()
        stackview.distribution = .fill
        stackview.axis = .vertical
        
        let label = SharedLabel(text: titleLabel)
        let textfield = SharedTextField(with: placeholder)
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
        
        let bottomInset = (self.navigationController?.navigationBar.frame.height ?? 0.0) + saveBtn.frame.height + 60
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }
    
    private func saveBtn(enabled: Bool) {
        DispatchQueue.main.async {
            self.saveBtn.isEnabled = enabled
            self.saveBtn.backgroundColor = enabled ? UIColor.Theme.accentBlue : .gray
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
                let height = self.view.safeAreaInsets.bottom - keyboardHeight
                self.scrollViewBottomConstraint.constant = height
                self.saveViewBottomConstraint.constant = height - CGFloat(self.saveBtnBottomOffset)
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
                self.scrollViewBottomConstraint.constant = 0
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
    }
}

extension ProfileViewController: SharedImagePickerDelegate {
    func didSelect(image: UIImage) {
        profileHeaderView?.imageView.image = image
        saveBtn(enabled: true)
    }
}

extension ProfileViewController: ProfileHeaderDelegate {
    func tappedAvatar() {
        imagePicker?.presentActionSheet()
    }
}


