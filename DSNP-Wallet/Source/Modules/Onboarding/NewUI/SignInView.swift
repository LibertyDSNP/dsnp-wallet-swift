//
//  SignInView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import SwiftUI

extension PresentationDetent {
    static let small = Self.height(100)
    static let extraLarge = Self.fraction(0.84)
}

struct SignInView: View {
    
    let viewModel: SignInViewModel
    
    @State private var termsPresented = false
        
    @AppStorage(AppStateKeys.hasAgreedToTerms.rawValue)
    private var hasAgreedToTerms: Bool = UserDefaults.standard.hasAgreedToTerms
    
    var body: some View {
        NavigationView {
            VStack {
                AmplicaLogo()
                    .padding(.top, 30)
                subtitle
                    .padding(.top, 2)
                description
                    .padding(.top, 8)
                buttonContainer
                    .padding(.top, 40)
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
        VStack {
            if !hasAgreedToTerms {
                Button {
                    termsPresented = true
                } label: {
                    Text("Restore Account")
                        .foregroundColor(.white)
                        .font(Font(UIFont.Theme.regular(ofSize: 14)))
                        .underline()
                }
                .sheet(isPresented: $termsPresented) {
                        TermsView()
                        .presentationDetents([.extraLarge])
                        .presentationDragIndicator(.visible)
                        .background(Color(uiColor: UIColor.Theme.bgGray))
                }
            } else {
                NavigationLink(
                    destination: LazyView(ImportSeedView(viewModel: ImportSeedViewModel()))) {
                        Text("Restore Account")
                            .foregroundColor(.white)
                            .font(Font(UIFont.Theme.regular(ofSize: 14)))
                            .underline()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 34)
                .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.restoreUserButton)
            }
        }
    }
    
    var haveAnIdButton: some View {
        Button {
            if !hasAgreedToTerms {
                termsPresented = true
            } else {
                print("we've agreed to terms")
                viewModel.meWeIdAction.send()
            }
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
                TermsView()
                .presentationDetents([.extraLarge])
                .presentationDragIndicator(.visible)
                .background(Color(uiColor: UIColor.Theme.bgGray))
        }
    }
    
    var createIdentityButton: some View {
        VStack {
            if !hasAgreedToTerms {
                PrimaryButton(title: "Create Identity") {
                    termsPresented = true
                }
                .padding(.horizontal, 34)
                .sheet(isPresented: $termsPresented) {
                        TermsView()
                        .presentationDetents([.extraLarge])
                        .presentationDragIndicator(.visible)
                        .background(Color(uiColor: UIColor.Theme.bgGray))
                }
            } else {
                NavigationLink(
                    destination: LazyView(ClaimHandleView(viewModel: ClaimHandleViewModel()))) {
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
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
