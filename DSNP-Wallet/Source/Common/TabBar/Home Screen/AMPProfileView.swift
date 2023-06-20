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
    
    @FocusState private var textfieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                profileImage
                handleHeadline
                VStack(alignment: .trailing) {
                    progressView
                    NavigationLink(destination: SocialProgressView(viewModel: SocialIdentityViewModel())) {
                        Text("See All")
                            .foregroundColor(Color(uiColor: UIColor.Theme.seeAllYellow))
                            .font(Font(UIFont.Theme.regular(ofSize: 10)))
                            .underline()

                    }
                    .padding(.top, -24)
                    .padding(.trailing, 38)
                    
                }
                .padding(.top, 30)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, 100)
            .background(Color(uiColor: UIColor.Theme.bgTeal))
            .ignoresSafeArea()
        }
    }
    
    private var profileImage: some View {
        ZStack(alignment: .bottomTrailing) {
            Image("profile_placeholder")
                .frame(maxWidth: 134, maxHeight: 134, alignment: .center)
                .cornerRadius(67)
            editButton
                .padding(.trailing, 2)
        }
        .frame(maxWidth: 150, maxHeight: 150, alignment: .center)
        .accessibilityIdentifier(AccessibilityIdentifier.TabView.IdentityViewIdentifiers.profileImage)
    }
    
    private var editButton: some View {
        Button {
            viewModel.toggleEditMode()
        } label: {
            Image("editButton")
        }
        .frame(maxWidth: 34, maxHeight: 34, alignment: .center)
        .background(Color(uiColor: UIColor.Theme.editButtonTeal))
        .cornerRadius(17)
    }
    
    private var handleHeadline: some View {
        Text(viewModel.chosenHandle)
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.white)
            .accessibilityIdentifier(AccessibilityIdentifier.TabView.IdentityViewIdentifiers.handle)
    }
    
    private var metaDatafields: some View {
        VStack {
            firstNameField
                .padding(.horizontal, 10)
            lastNameField
                .padding(.horizontal, 10)
            emailField
                .padding(.horizontal, 10)
        }
    }

    private var progressView: some View {
        SocialIdentityProgressView(viewModel: SocialIdentityViewModel())
            .accessibilityIdentifier(AccessibilityIdentifier.TabView.IdentityViewIdentifiers.progressIndicator)
    }
    
    private var frequencyReward: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("freqLogo")
                    .frame(width: 40, height: 40)
                    .padding(.leading, 12)
                    .padding(.trailing, 16)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Frequency")
                            .font(Font(UIFont.Theme.italic(ofSize: 14)))
                            .foregroundColor(.white)
                            .padding(.trailing, -2)
                        Text("Reward")
                            .font(Font(UIFont.Theme.regular(ofSize: 14)))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 6)
                    HStack {
                        Text("400")
                            .font(Font(UIFont.Theme.bold(ofSize: 36)))
                            .foregroundColor(.white)
                        Text("FRQCY")
                            .font(Font(UIFont.Theme.regular(ofSize: 12)))
                            .foregroundColor(.white)
                            .frame(alignment: .bottom)
                            .padding(.top, 12)
                    }
                    .padding(.top, -12)
                }
            }
            .padding(.bottom, 2)
            claimNowButton
        }
        .padding()
        .background(Color(uiColor: UIColor.Theme.freqBackground))
        .cornerRadius(10)
        .accessibilityIdentifier(AccessibilityIdentifier.TabView.IdentityViewIdentifiers.initialClaimBanner)

    }
    
    private var claimNowButton: some View {
        Button {
        } label: {
            Text("Claim now")
                .font(Font(UIFont.Theme.bold(ofSize: 15)))
                .foregroundColor(.white)
                .padding(.vertical, 7)
        }
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 5).fill(Color(uiColor: UIColor.Theme.primaryTeal)))
        .accessibilityIdentifier(AccessibilityIdentifier.TabView.IdentityViewIdentifiers.claimNowButton)
    }
    
    private var firstNameField: some View {
        VStack {
            Text("First name:")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 2)
            TextField("First Name:", text: $viewModel.firstNameText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
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
    }
    
    private var lastNameField: some View {
        VStack {
            Text("Last Name:")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 2)
            TextField("Last Name:", text: $viewModel.lastNameText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 30).fill(bgTealColor))
                .font(Font(UIFont.Theme.regular(ofSize: 16)))
                .foregroundColor(.white)
                .focused($textfieldFocused)
                .border(.white)
                .accessibilityIdentifier(AccessibilityIdentifier.TabView.ProfileViewIdentifiers.profileIdentifierLastNameField)
        }
    }
    
    private var emailField: some View {
        VStack {
            Text("Email:")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 2)
            TextField("Email:", text: $viewModel.emailText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
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
}
