//
//  CongratsViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/9/23.
//

import UIKit
import SwiftUI
import Combine

class CongratsViewController: UIHostingController<CongratsModal> {
    
    var cancellables = [AnyCancellable]()
    
    init() {
        super.init(rootView: CongratsModal(isPresented: .constant(false)))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
