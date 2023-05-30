//
//  AMPProfileView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import SwiftUI

let bgTealColor = Color(uiColor: UIColor.Theme.bgTeal)

struct AMPProfileView: View {
    
    @ObservedObject var viewModel: AMPHomeViewModel
    
    @State var showingAlert: Bool = false

    @FocusState private var textfieldFocused: Bool

    
    var body: some View {
        ZStack {
            if showingAlert {
                CongratsModal(viewModel: CongratsViewModel())
            }
            VStack {
                profileImage
                handleHeadline
                addressSubheadline
                metaDatafields
            }
            .background(Color(uiColor: UIColor.Theme.bgTeal))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
    
    private var profileImage: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("profile_placeholder")
            editButton
        }
        .frame(maxWidth: 120, maxHeight: 120, alignment: .center)
        .cornerRadius(60)
    }
    
    private var editButton: some View {
        Button {
            viewModel.toggleEditMode()
        } label: {
            Image("editButton")
        }
        .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
        .background(Color(uiColor: UIColor.Theme.primaryTeal))
        .cornerRadius(8)
    }
    
    private var handleHeadline: some View {
        Text("handle goes here")
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.white)
    }
    
    private var addressSubheadline: some View {
        HStack {
            Text(viewModel.walletAddress)
                .font(Font(UIFont.Theme.thin(ofSize: 14)))
                .foregroundColor(.white)
            Button {
                UIPasteboard.general.string = viewModel.walletAddress
            } label: {
                Image("copyButton")
            }
        }
    }
    
    private var metaDatafields: some View {
        VStack {
            firstNameField
            lastNameField
            emailField
        }
    }
    
    private var firstNameField: some View {
        TextField("First Name:", text: $viewModel.firstNameText)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 30).fill(bgTealColor))
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.white)
            .focused($textfieldFocused)
            .border(.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.textfieldFocused = true
                }
            }
            .accessibilityIdentifier(AccessibilityIdentifier.TabView.ProfileViewIdentifiers.profileIdentifierFirstNameField)
        
        
    }
    
    private var lastNameField: some View {
        TextField("Last Name:", text: $viewModel.lastNameText)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 30).fill(bgTealColor))
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.white)
            .focused($textfieldFocused)
            .border(.white)
            .accessibilityIdentifier(AccessibilityIdentifier.TabView.ProfileViewIdentifiers.profileIdentifierLastNameField)
    }
    
    private var emailField: some View {
        TextField("Email:", text: $viewModel.emailText)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .foregroundColor(.black)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 30).fill(bgTealColor))
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.white)
            .focused($textfieldFocused)
            .border(.white)
            .accessibilityIdentifier(AccessibilityIdentifier.TabView.ProfileViewIdentifiers.profileIdentifierEmailField)
    }
}
