//
//  NotificationCenter+Duplicates.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 7/6/22.
//

import Foundation

extension NotificationCenter {
    func setObserver(_ observer: Any, selector: Selector, name: Notification.Name, object: Any?) {
        removeObserver(observer, name: name, object: object)
        addObserver(observer, selector: selector, name: name, object: object)
    }
}
