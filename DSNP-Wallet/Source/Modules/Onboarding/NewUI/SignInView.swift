//
//  SignInView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        VStack {
            ScrollView {
                
            }
            agreeContainer
        }
    }
    
    var agreeContainer: some View {
        Rectangle()
    }
}

struct SignInView: View {
    
    let viewModel: SignInViewModel
    
    @State private var termsPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                AmplicaLogo()
                    .padding(.top, 68)
                subtitle
                    .padding(.vertical, 10)
                description
                    .padding(.vertical, 12)
                buttonContainer
                Spacer()
                SignInTermsDisclaimerView()
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            .background(Color(uiColor: UIColor.Theme.bgTeal))
        }
        .navigationBarHidden(true)
    }
    
    var subtitle: some View {
        Text(" It’s Your identity.\nYou should own it")
            .font(Font(UIFont.Theme.regular(ofSize: 20)))
            .foregroundColor(.white)
    }
    
    var description: some View {
        Text("Amplica Access is leading the migration to the\nSocial Web so you can take control of your data.\nYou can even take your digital identity with you.")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.white)
            .lineSpacing(3)
    }
    
    var buttonContainer: some View {
        VStack {
            createIdentityButton
            haveAnIdButton
            restoreButton
        }
        .frame(maxWidth: .infinity)
    }
    
    var restoreButton: some View {
        NavigationLink(destination: LazyView(ImportSeedView(viewModel: ImportSeedViewModel()))) {
            Text("Restore Account")
                .foregroundColor(.white)
                .font(Font(UIFont.Theme.regular(ofSize: 14)))
                .underline()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 34)
        .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.restoreUserButton)

    }
    
    var haveAnIdButton: some View {
        Button {
            viewModel.meWeIdAction.send()
            termsPresented.toggle()
        } label: {
            HStack {
                Text("I have an ID")
                    .font(Font(UIFont.Theme.medium(ofSize: 14)))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                Image("mewelogo")
                        .padding(.bottom, 6)
                        .padding(.leading, -15)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.Theme.buttonTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
        .padding(.vertical, 12)
        .padding(.horizontal, 34)
        .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.createUserMeWeButton)
        .sheet(isPresented: $termsPresented) {
            if #available(iOS 16.0, *) {
                TermsView()
            } else {
                Text("get ios 16")
            }
        }
    }
    
    var createIdentityButton: some View {
        NavigationLink {
           LazyView(ClaimHandleView(viewModel: ClaimHandleViewModel()))
        } label: {
            Text("Create Identity")
                .font(Font(UIFont.Theme.medium(ofSize: 14)))
                .padding(.vertical, 16)
                .padding(.horizontal, 34)
                .foregroundColor(.white)
        }
        .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.createNewUserButton)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.Theme.buttonTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
        .padding(.vertical, 10)
        .padding(.horizontal, 34)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
