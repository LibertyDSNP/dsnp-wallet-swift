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
                .padding(.bottom, 20)
                .padding(.horizontal, 30)
            recoverySection
                .padding(.bottom, 30)
                .padding(.horizontal, 30)
            VStack {
                security
                faceIdCell
                password
                logoutButton
                Spacer()
            }
           
        }
        .padding(.top, 70)
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
        VStack(alignment: .leading) {
            if !AppState.shared.hasBackedKeys {
                Text("You have NEVER backed up!")
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                Text("Recovery phrase is very important you better write this down")
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .foregroundColor(.white)
                    .padding(.bottom, 16)
            }
            SecondaryButton(title: "Reveal Recovery Phrase") {
                // TODO: Navigate to seed flow
            }
            .frame(minHeight: 60)
        }
    }
    
    private var security: some View {
            VStack(alignment: .leading) {
                Text("Security")
                    .font(Font(UIFont.Theme.bold(ofSize: 14)))
                    .foregroundColor(.white)
                    .padding(.bottom, -2)
                Text("Adding additional security is really important")
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .foregroundColor(.white)
            }
            .padding(.leading, -60)
            .padding(.bottom, 30)
    }
    
    private var faceIdCell: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Face ID")
                    .font(Font(UIFont.Theme.bold(ofSize: 14)))
                    .foregroundColor(.white)
                    .padding(.bottom, -2)
                Text("Increase access security with Face ID")
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .foregroundColor(.white)
            }
            Toggle("", isOn: .constant(true))
        }
        .padding(.bottom, 30)
        .padding(.horizontal, 30)
    }
    
    private var password: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Password")
                    .font(Font(UIFont.Theme.bold(ofSize: 14)))
                    .foregroundColor(.white)
                    .padding(.bottom, -2)
                Text("Password to log in to your account")
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(.bottom, 30)
        .padding(.horizontal, 30)
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
