//
//  SignInViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import UIKit
import SwiftUI

class SignInViewController: UIHostingController<SignInView> {

    init() {
        super.init(rootView: SignInView())
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
