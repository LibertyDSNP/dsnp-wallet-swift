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
        VStack {
            profileImage
            handleHeadline
            progressView
            seeAllButton
                .frame(alignment: .trailing)
                .padding(.top, -12)
            frequencyReward
                .padding()
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
    
    private var profileImage: some View {
        ZStack(alignment: .bottomTrailing) {
            editButton
                .padding(.trailing, 20)
            Image("profile_placeholder")
        }
        .frame(maxWidth: 134, maxHeight: 134, alignment: .center)
        .cornerRadius(67)
    }
    
    private var editButton: some View {
        Button {
            viewModel.toggleEditMode()
        } label: {
            Image("editButton")
        }
        .frame(maxWidth: 24, maxHeight: 24, alignment: .center)
        .background(Color(uiColor: UIColor.Theme.primaryTeal))
        .cornerRadius(12)
    }
    
    private var handleHeadline: some View {
        Text("handle goes here")
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.white)
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
    }
    
    private var seeAllButton: some View {
        Button {
            // See All Navigation
        } label: {
            Text("See All")
                .foregroundColor(Color(uiColor: UIColor.Theme.seeAllYellow))
                .font(Font(UIFont.Theme.regular(ofSize: 10)))
                .underline()
        }
    }
    
    private var frequencyReward: some View {
        VStack {
            HStack {
                Image("freqLogo")
                VStack {
                    HStack {
                        Text("Frequency")
                            .font(Font(UIFont.Theme.italic(ofSize: 14)))
                            .foregroundColor(.white)
                        Text("Reward")
                            .font(Font(UIFont.Theme.regular(ofSize: 14)))
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("\(viewModel.rewardAmount)")
                            .font(Font(UIFont.Theme.bold(ofSize: 22)))
                            .foregroundColor(.white)
                        Text("FRQCY")
                            .font(Font(UIFont.Theme.regular(ofSize: 12)))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 6)
                }
                .padding(.top, 12)
            }
            claimNowButton
        }
        .cornerRadius(10)
        .background(Color(uiColor: UIColor.Theme.freqBackground))
    }
    
    private var claimNowButton: some View {
        Button {
            // claim now action
        } label: {
            Text("Claim now")
                .font(Font(UIFont.Theme.bold(ofSize: 15)))
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.Theme.primaryTeal))
        .cornerRadius(5)
        .frame(height: 30)
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
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
