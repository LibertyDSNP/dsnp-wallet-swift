//
//  SignInView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import SwiftUI
import SafariServices

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
    
    // MARK: Restore Button
    
    var restoreButton: some View {
        VStack {
            if !hasAgreedToTerms {
                restoreButtonTerms
            } else {
                restoreButtonNavigation
            }
        }
    }
    
    var restoreButtonTerms: some View {
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
    }
    
    var restoreButtonNavigation: some View {
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
    
    // MARK: Have an ID Button
    
    var haveAnIdButton: some View {
        VStack {
            if !hasAgreedToTerms {
                haveAnIdButtonTerms
            } else {
                haveAnIdButtonNavigation
            }
        }
    }
    
    var haveAnIdButtonNavigation: some View {
        Button {
            if !hasAgreedToTerms {
                termsPresented = true
            } else {
                let vc = SFSafariViewController(url: URL(string: "https://dev-custodial-wallet.liberti.social/access_web/index.html")!)

                UIApplication.shared.firstKeyWindow?.rootViewController?.present(vc, animated: true)
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
    }
    
    var haveAnIdButtonTerms: some View {
        Button {
            if !hasAgreedToTerms {
                termsPresented = true
            } else {
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
    
    // MARK: Create Identity Button
    
    var createIdentityButton: some View {
        VStack {
            if !hasAgreedToTerms {
                createButtonTerms
            } else {
                createButtonNavigation
            }
        }
    }
    
    var createButtonTerms: some View {
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
    }
    
    var createButtonNavigation: some View {
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

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
