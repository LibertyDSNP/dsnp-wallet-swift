//
//  ClaimHandleViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/5/23.
//

import UIKit
import SwiftUI

class ClaimHandleViewController: UIHostingController<ClaimHandleView> {

    init() {
        super.init(rootView: ClaimHandleView())
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
