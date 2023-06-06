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
            security
            faceIdCell
            password
            logoutButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
    
    private var headline: some View {
        Text("Settings")
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.white)
    }
    
    private var recoverySection: some View {
        VStack {
            if !AppState.shared.hasBackedKeys {
                Text("You Haven't backed up")
                    .font(Font(UIFont.Theme.thin(ofSize: 12)))
                    .foregroundColor(.white)
                Text("Back it up")
                    .font(Font(UIFont.Theme.thin(ofSize: 12)))
                    .foregroundColor(.white)
            }
            PrimaryButton(title: "Reveal Recovery Phrase") {
                // TODO: Navigate to seed flow
            }
        }
    }
    
    private var security: some View {
        VStack {
            Text("Security")
                .font(Font(UIFont.Theme.bold(ofSize: 14)))
                .foregroundColor(.white)
            Text("Adding additional security is really important")
                .font(Font(UIFont.Theme.thin(ofSize: 12)))
                .foregroundColor(.white)
        }
    }
    
    private var faceIdCell: some View {
        HStack {
            VStack {
                Text("Face ID")
                    .font(Font(UIFont.Theme.bold(ofSize: 14)))
                    .foregroundColor(.white)
                Text("Increase access security with Face ID")
                    .font(Font(UIFont.Theme.thin(ofSize: 12)))
                    .foregroundColor(.white)
            }
            Toggle("Increase access security with Face ID", isOn: .constant(true))
        }
    }
    
    private var password: some View {
        HStack {
            VStack {
                Text("Password")
                    .font(Font(UIFont.Theme.bold(ofSize: 14)))
                    .foregroundColor(.white)
                Text("Password to log in to your account")
                    .font(Font(UIFont.Theme.thin(ofSize: 12)))
                    .foregroundColor(.white)
            }
            Spacer()
            // arrow
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
