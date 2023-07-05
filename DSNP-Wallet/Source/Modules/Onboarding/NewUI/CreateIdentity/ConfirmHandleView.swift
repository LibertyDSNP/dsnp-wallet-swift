//
//  ConfirmHandleView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import SwiftUI

struct ConfirmHandleView: View {
    @ObservedObject var viewModel: ConfirmHandleViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            AmplicaHeadline(withBackButton: true) {
                dismiss()
            }
            BaseRoundView {
                stepCount
                subtitle
                handle
                nextButton
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                suffixDescription
            }
        }
        .navigationBarHidden(true)
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var stepCount: some View {
        VStack {
            Text("2 of 3")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
            Text("Create Digital Identity")
                .font(Font(UIFont.Theme.medium(ofSize: 12)))
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var subtitle: some View {
        Text("Confirm your Handle")
            .font(Font(UIFont.Theme.medium(ofSize: 22)))
            .foregroundColor(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var handle: some View {
        Text(viewModel.chosenHandle)
            .font(Font(UIFont.Theme.regular(ofSize: 16)))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.confirmHandleLabel)
    }

    private var nextButton: some View {
        NavigationLink(destination: AgreeToTermsView(viewModel: AgreeToTermsViewModel(chosenHandle: viewModel.chosenHandle))) {
            Text("Next")
                .font(Font(UIFont.Theme.medium(ofSize: 14)))
                .padding(.vertical, 16)
                .padding(.horizontal, 34)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.Theme.buttonTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
        .padding(.vertical, 10)
        .padding(.horizontal, 34)
        .contentShape(Rectangle())
        .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.confirmHandleButton)
    }
    
    private var suffixDescription: some View {
        Text("The numerical suffix is auto-assigned by Amplica Access\nto make sure every handle is unique. They will not be\nvisible in some cases.")
            .font(Font(UIFont.Theme.regular(ofSize: 11)))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)

    }
}

struct ConfirmHandleView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmHandleView(viewModel: ConfirmHandleViewModel(chosenHandle: "benIsCool"))
    }
}
