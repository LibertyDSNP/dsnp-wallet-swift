//
//  SharedImagePicker.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 5/9/22.
//

import UIKit

class SharedImagePicker: NSObject {
    
    private weak var parent: UIViewController?
    private var pickerImageView: UIImageView?
    private var saveBlock: ((Bool)->()) = { _ in }
    
    init(parent: UIViewController?, imageView: UIImageView, saveBlock: @escaping ((Bool)->())) {
        self.parent = parent
        self.pickerImageView = imageView
        self.saveBlock = saveBlock
    }
    
    internal func presentActionSheet() {
        parent?.view.endEditing(true)
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: "Take photo", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.sourceType = .camera
            vc.allowsEditing = true
            self.parent?.present(vc, animated: true)
        }
        
        let uploadAction = UIAlertAction(title: "Upload photo", style: .default) { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self
            self.parent?.present(vc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        
        actionSheetController.addAction(takeAction)
        actionSheetController.addAction(uploadAction)
        actionSheetController.addAction(cancelAction)
        
        parent?.present(actionSheetController, animated: true, completion: nil)
    }
}

extension SharedImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let imageView = pickerImageView else { return }
        imageView.image = nil
        picker.dismiss(animated: true)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        imageView.addSubview(activityIndicator)
        activityIndicator.layoutAttachAll(to: imageView)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        saveBlock(false)
        
        DispatchQueue.main.async {
            self.pickerImageView?.image = image
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.saveBlock(true)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
