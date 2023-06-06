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
            headline
            recoverySection
            logoutButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
    
    private var headline: some View {
        Text("Settings")
    }
    
    private var recoverySection: some View {
        VStack {
            if !AppState.shared.hasBackedKeys {
                Text("You Haven't backed up")
                Text("Back it up")
            }
            PrimaryButton(title: "Reveal Recovery Phrase") {
                // TODO: Navigate to seed flow
            }
        }
    }
    
    private var security: some View {
        VStack {
            Text("Security")
            Text("Adding additional security is really important")
        }
    }
    
    private var faceIdCell: some View {
        HStack {
            VStack {
                
            }
            
        }
    }
    
    
    private var logoutButton: some View {
        Button("log out") {
            // Nav to sign in view
            viewModel.logoutAction.send()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: HomeViewModel())
    }
}
