//
//  DeeplinkManager.swift
//  dsnp-wallet
//
//  Created by Ryan Sheh on 6/22/22.
//

import Foundation
import DSNPWallet
import UIKit

enum Notifications: String {
    case retrievedKeys
}

class DeeplinkManager {
    private var callback: String?
    private var message: String?
    
    func set(with url: URL?) {
        guard let url = url else { return }
        callback = url.components?["x-callback-url"]
        message = url.components?["message"]
    }
    
    func signMsg() {
        guard let callback = callback,
              let message = message else { return }
        
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
