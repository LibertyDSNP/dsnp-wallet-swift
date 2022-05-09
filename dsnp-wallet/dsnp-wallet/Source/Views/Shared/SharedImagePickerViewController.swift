//
//  SharedImagePickerViewController.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 5/9/22.
//

import UIKit

class SharedImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pickerImageView: UIImageView?
    var toggleSaveBtnBlock: ((Bool)->()) = { _ in }
    
    internal func presentActionSheet() {
        self.view.endEditing(true)
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: "Take photo", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.sourceType = .camera
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
              let imageView = pickerImageView else { return }
        imageView.image = nil
        picker.dismiss(animated: true)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        imageView.addSubview(activityIndicator)
        activityIndicator.layoutAttachAll(to: imageView)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        toggleSaveBtnBlock(false)
        
        DispatchQueue.main.async {
            self.pickerImageView?.image = image
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            self.toggleSaveBtnBlock(true)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
