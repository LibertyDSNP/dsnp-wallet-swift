//
//  CongratsModal.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import SwiftUI

struct CongratsModal: View {

    let viewModel: CongratsViewModel
    
    @State var shown: Bool = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                EmptyView()
                Spacer()
                congratsText
                    .padding(.top, 20)
                    .padding(.leading, 16)
                Spacer()
                CloseButton(action: {
                    shown.toggle()
                })
                .padding(.trailing, 12)
                .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.congratsCloseButton)
            }
            description
            buttonStack
        }
        .background(Color(uiColor: UIColor.Theme.bgGray))
        .frame(maxWidth: 300, maxHeight: 300, alignment: .topTrailing)
        .cornerRadius(20)
        .padding(16)
    }

    private var congratsText: some View {
        Text("Congratulations!")
            .font(Font(UIFont.Theme.extraBold(ofSize: 22)))
            .foregroundColor(Color(uiColor: UIColor.Theme.congratsColor))
    }
    
    private var buttonStack: some View {
        VStack {
            finishButton
                .padding(.horizontal, 30)
            skipButton
        }
        .padding(16)
    }
    
    private var description: some View {
        Text("For better recommendations and\nto connect with people relevant to you filling\nout your profile is a good first step.")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
            .lineSpacing(4)
            .padding(.vertical, 14)
    }
    
    private var finishButton: some View {
        PrimaryButton(title: "Finish Digital Identity") {
            viewModel.finishAction.send()
            shown.toggle()
        }
        .font(Font(UIFont.Theme.regular(ofSize: 14)))
        .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.congratsFinishButton)
    }
    
    private var skipButton: some View {
        Button {
            viewModel.skipAction.send()
            shown.toggle()
        } label: {
            Text("Skip for now (Not Recommended)")
                .foregroundColor(Color(uiColor: UIColor.Theme.defaultTextColor))
                .font(Font(UIFont.Theme.regular(ofSize: 10)))
                .underline()
        }
        .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.congratsSkipButton)
    }
}

struct CongratsModal_Previews: PreviewProvider {
    static var previews: some View {
        CongratsModal(viewModel: CongratsViewModel())
    }
}
