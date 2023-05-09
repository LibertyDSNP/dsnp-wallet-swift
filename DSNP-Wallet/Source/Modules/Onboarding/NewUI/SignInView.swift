//
//  SignInView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import SwiftUI

struct SignInView: View {
    
    let viewModel: SignInViewModel
    
    var body: some View {
        VStack {
            AmplicaLogo()
                .padding(.top, 68)
            subtitle
                .padding(.vertical, 10)
            description
                .padding(.vertical, 12)
            buttonContainer
            Spacer()
            termsView
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(Color(uiColor: UIColor.Theme.bgTeal))
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
            PrimaryButton(title: "I have an ID (MeWe)", action: {
                viewModel.meWeIdAction.send()
            })
            .padding(.vertical, 12)
            .padding(.horizontal, 34)
            PrimaryButton(title: "Restore from backup", action: {
                viewModel.restoreAction.send()
            })
            .padding(.vertical, 12)
            .padding(.horizontal, 34)
        }
        .frame(maxWidth: .infinity)
    }
    
    var termsView: some View {
        Text("By signing up, you agree to our [Terms](https://google.com) and\n[Privacy Policy](https://google.com)")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.white)
            .lineSpacing(3)
            .padding(.bottom, 16)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
