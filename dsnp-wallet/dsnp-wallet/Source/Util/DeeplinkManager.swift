//
//  DeeplinkManager.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 6/22/22.
//

import Foundation
import DSNPWallet
import UIKit

enum NotificationType: String, CaseIterable {
    case retrievedKeys = "Hello World"
    case navigateToProfile = "NavigateToVC"
}

protocol DeeplinkManagerProtocol: AnyObject {
    func performDeepLinkAction(_ action: NotificationType)
}

class DeeplinkManager {
    //MARK: Constants
    let _callbackUrl = "x-callback-url"
    let _message = "message"
    
    var viewController: UIViewController?
    weak var delegate: DeeplinkManagerProtocol?
    
    private let lock = NSLock()
    private var urls: [URL] = [] {
        didSet {
            self.lock.lock()
            handleNextDeeplink(completion: {
                self.urls.removeFirst()
                self.lock.unlock()
            })
        }
    }
    private var waitingForKeys = false
    
    func add(url: URL?) {
        guard let url = url else { return }
        urls.append(url)
    }
    
    private func handleNextDeeplink(completion: (()->())?) {
        guard !waitingForKeys,
              let url = urls.first,
              let message = url.components?[_message] else {
            completion?()
            return
        }
        
        switch message {
        case NotificationType.retrievedKeys.rawValue:
            self.addRetrievedKeysObserver(completion: completion)
        case NotificationType.navigateToProfile.rawValue:
            self.navigateToProfile(completion: completion)
        default:
            completion?()
            return
        }
    }
    
    private func navigateToProfile(completion: (()->())?) {
        //TODO: Deeplinking into different parts of the app
        completion?()
    }
}

//MARK: Observer for Key Retrieval
extension DeeplinkManager {
    private func addRetrievedKeysObserver(completion: (()->())?) {
        waitingForKeys = true
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationType.retrievedKeys.rawValue),
                                               object: nil,
                                               queue: nil) { notification in
            
            self.retrievedKeys(notification: notification)
            completion?()
        }
    }
    
    @objc func retrievedKeys(notification: Notification) {
        defer { waitingForKeys = false }
        
        let callback = urls.first?.components?[_callbackUrl]
        let message = urls.first?.components?[_message]

        guard let message = message,
              message == NotificationType.retrievedKeys.rawValue else { return }
        
        signMsg(with: message, callback: callback)
        
        func signMsg(with message: String, callback: String?) {
            let data = try? DSNPWallet().sign(message)
            
            var components = URLComponents()
            components.scheme = callback
            components.host = ""
            if let data = data {
                let dataString = data.base64EncodedString()
                components.queryItems = [
                    URLQueryItem(name: "result", value: dataString),
                ]
            } else {
                components.queryItems = [
                    URLQueryItem(name: "x-cancel", value: "Unable to sign request."),
                ]
            }
            
            if let url = components.url {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print(success)
                })
            } else {
                print("Invalid url")
            }
         }
    }
}
