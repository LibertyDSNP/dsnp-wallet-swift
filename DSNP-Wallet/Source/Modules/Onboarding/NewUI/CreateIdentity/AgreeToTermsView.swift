//
//  AgreeToTermsView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import SwiftUI

struct AgreeToTermsView: View {
    
    let viewModel: AgreeToTermsViewModel

    var body: some View {
        VStack {
            AmplicaLogo()
            BaseRoundView {
                stepCount
                subtitle
                handle
                agreementText
                agreementExplanationText
                agreeButton
                TermsDisclaimerView()
                    .padding(.top, 120)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var stepCount: some View {
        VStack {
            Text("3 of 3")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
            Text("Create Digital Identity")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var subtitle: some View {
        Text("Agree to Terms")
            .font(Font(UIFont.Theme.regular(ofSize: 22)))
            .foregroundColor(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var handle: some View {
        Text(viewModel.chosenHandle)
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.agreeConfirmHandleLabel)
    }
    
    private var agreementText: some View {
        Text("By agreeing, you grant Amplica access\nto your digital identity to:")
            .font(Font(UIFont.Theme.medium(ofSize: 12)))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
    }
    
    private var agreementExplanationText: some View {
        VStack {
            BulletListView(listItems: ["Update your handle and profile information", "Update your contacts & groups"])
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
            Text("You may update permissions at any time.")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var agreeButton: some View {
        PrimaryButton(title: "Agree") {
            viewModel.agreeAction.send()
        }
        .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.agreeButton)
    }
}

struct AgreeToTermsView_Previews: PreviewProvider {
    static var previews: some View {
        AgreeToTermsView(viewModel: AgreeToTermsViewModel(chosenHandle: "aChosenHandle"))
    }
}
