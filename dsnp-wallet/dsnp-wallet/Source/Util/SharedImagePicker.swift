//
//  SharedImagePicker.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 5/9/22.
//

import UIKit

protocol SharedImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage)
}

class SharedImagePicker: NSObject {
    private weak var parent: UIViewController?
    public weak var delegate: SharedImagePickerDelegate?
    
    init(parent: UIViewController?) {
        self.parent = parent
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
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        picker.dismiss(animated: true)
        
        DispatchQueue.main.async {
            self.delegate?.didSelect(image: image)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
