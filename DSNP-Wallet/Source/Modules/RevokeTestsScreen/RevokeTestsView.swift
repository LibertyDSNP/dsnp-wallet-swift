//
//  RevokeTestsView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/22/23.
//

import SwiftUI

struct RevokeTestsView: View {
    
    let viewModel: RevokeTestsViewModel
    
    var body: some View {
        VStack {
            setupMSAButton
        }
    }
    
    private var setupMSAButton: some View {
        PrimaryButton(title: "Set up MSA", action: {
            // view model call
        })
        .padding(.horizontal, 20)
    }
}

