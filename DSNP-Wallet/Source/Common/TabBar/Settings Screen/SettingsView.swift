//
//  SettingsView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/1/23.
//

import SwiftUI

struct SettingsView: View {
        
    let viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            logoutButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
    
    private var logoutButton: some View {
        Button("log out") {
            // Nav to sign in view
            viewModel.toggleLoggedInState()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: HomeViewModel())
    }
}
