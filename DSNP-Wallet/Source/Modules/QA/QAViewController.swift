//
//  QAViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/1/23.
//

import UIKit
import SwiftUI

class QAViewController: UIHostingController<QAView> {

    init() {
        super.init(rootView: QAView())
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
