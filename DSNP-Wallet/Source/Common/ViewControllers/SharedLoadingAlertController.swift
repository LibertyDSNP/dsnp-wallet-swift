//
//  SharedLoadingAlertController.swift
//  UsNative
//
//  Created by Rigo Carbajal on 6/11/21.
//

import UIKit

class SharedLoadingAlertController {
    
    private weak var parent: UIViewController?
    private var alertController: UIAlertController?
    
    // Imagine you want to present a loading alert for a given task.
    // This task has a runtime of anywhere between 0.1 seconds to 3 seconds.
    // If you call presentLoadingView, then call dismissLoadingView after
    // 0.1 seconds, what happens? Because the alert takes 0.3 seconds or
    // so to fully present (with animation), dismiss will have no effect,
    // because the alert is not yet fully presented. To account for this,
    // we track whether or not the alert is in the process of being presented.
    // If we try dismissing alert during this state, we set a completion
    // block to handle the dismissal as soon as the alert is fully presented.
    private var isBeingPresented: Bool = false
    private var didPresent: (() -> Void)?
    
    init(parent: UIViewController?) {
        self.parent = parent
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        alertController.view.addSubview(activityIndicator)
        alertController.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -20).isActive = true
        self.alertController = alertController
    }
    
    public func presentLoadingView(title: String?) {
        if let alertController = self.alertController,
           !(self.parent?.presentedViewController is UIAlertController) {
            alertController.title = title
            self.isBeingPresented = true
            self.parent?.present(alertController, animated: true) { [weak self] in
                guard let self = self else { return }
                self.isBeingPresented = false
                self.didPresent?()
            }
        }
    }
    
    public func dismissLoadingView(completion: (() -> Void)? = nil) {
        if self.isBeingPresented {
            self.didPresent = { [weak self] in
                guard let self = self else { return }
                self.alertController?.dismiss(animated: true, completion: completion)
                self.didPresent = nil
            }
        } else {
            self.alertController?.dismiss(animated: true, completion: completion)
        }
    }
}

