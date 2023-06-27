//
//  SignInView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import SwiftUI

struct SignInViewControllerWrapper : UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let signInViewController = SignInViewController()
        let navController = UINavigationController()
        navController.setViewControllers([signInViewController], animated: true)
        return navController
    }
}

struct SignInView: View {
    
    let viewModel: SignInViewModel
    
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
            PrimaryButton(title: "Create Identity", action: {
                viewModel.createIdentityAction.send()
            })
            .padding(.vertical, 12)
            .padding(.horizontal, 34)
            .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.createNewUserButton)
            PrimaryButton(title: "I have an ID", action: {
                viewModel.meWeIdAction.send()
            }, suffixImage: Image("mewelogo"))
            .padding(.vertical, 12)
            .padding(.horizontal, 34)
            .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.createUserMeWeButton)
            NavigationLink(destination: ImportSeedViewControllerWrapper()) {
                Text("Restore Account")
                    .foregroundColor(.white)
                    .font(Font(UIFont.Theme.regular(ofSize: 14)))
                    .underline()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 34)
            .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.restoreUserButton)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
