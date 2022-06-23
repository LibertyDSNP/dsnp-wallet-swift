//
//  HomeViewController.swift
//  UnfinishedWallet
//
//  Created by Ryan Sheh on 4/25/22.
//

import Foundation
import UIKit

class HomeViewController: SharedProfileHeaderViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: Notification.Name(Notifications.retrievedKeys.rawValue),
                                        object: nil)
    }
}
