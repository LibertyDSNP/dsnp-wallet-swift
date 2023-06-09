//
//  AMPHomeViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import UIKit

class AMPHomeViewModel: ObservableObject {

    @Published var firstNameText = ""
    @Published var lastNameText = ""
    @Published var emailText = ""

    @Published var isEditing: Bool = false    
    
    let rewardAmount: Int = 400
    
    
    func toggleEditMode() {
        isEditing.toggle()
    }
    
}
