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

    var chosenHandle: String
    
    init(chosenHandle: String) {
        self.chosenHandle = chosenHandle
    }
    
    func toggleEditMode() {
        isEditing.toggle()
    }
}
