//
//  CongratsModal.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import SwiftUI

enum AlertType {
    case congrats
    
    func title() -> String {
        switch self {
        case .congrats:
            return "Congratulations!"
        }
    }
    
    func message() -> String {
        switch self {
        case .congrats:
            return "For better recommendations and\nto connect with people relevant to you filling\nout your profile is a good first step."
        }
    }
    
    func primaryActionText() -> String {
        switch self {
        case .congrats:
            return "Finish Digital Identity"
        }
    }
    
    func secondaryActionText() -> String {
        switch self {
        case .congrats:
            return "Skip for now (Not Recommended)"
        }
    }
    
    func closeButtonAccessibilityId() -> String {
        switch self {
        case .congrats:
            return AccessibilityIdentifier.OnboardingIdentifiers.congratsCloseButton
        }
    }
    
    func primaryButtonAccessibilityId() -> String {
        switch self {
        case .congrats:
            return AccessibilityIdentifier.OnboardingIdentifiers.congratsCloseButton
        }
    }
    
    func secondaryButtonAccessibilityId() -> String {
        switch self {
        case .congrats:
            return AccessibilityIdentifier.OnboardingIdentifiers.congratsCloseButton
        }
    }
}

struct AmplicaAlert: View {

    @Binding var presentAlert: Bool
    
    let alertType: AlertType

    let primaryButtonAction: () -> ()
    let secondaryButtonAction: () -> ()?

    var body: some View {
        VStack {
            headline
            messageText
            buttonStack
        }
        .background(Color(uiColor: UIColor.Theme.bgGray))
        .cornerRadius(20)
        .padding(16)
    }
    
    private var headline: some View {
        HStack(alignment: .center) {
            EmptyView()
            Spacer()
            titleText
                .padding(.top, 20)
                .padding(.leading, 16)
            Spacer()
            CloseButton(action: {
                presentAlert.toggle()
            })
            .padding(.trailing, 12)
            .accessibilityIdentifier(alertType.closeButtonAccessibilityId())
        }
    }
    
    private var titleText: some View {
        Text(alertType.title())
            .font(Font(UIFont.Theme.extraBold(ofSize: 22)))
            .foregroundColor(Color(uiColor: UIColor.Theme.congratsColor))
    }
    
    private var messageText: some View {
        Text(alertType.message())
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
            .lineSpacing(4)
            .padding(.vertical, 14)
    }
    
    
    private var buttonStack: some View {
        VStack {
            primaryActionButton
                .padding(.horizontal, 30)
            secondaryActionButton
        }
        .padding(16)
    }
    
    private var primaryActionButton: some View {
        PrimaryButton(title: alertType.primaryActionText()) {
            presentAlert.toggle()
            primaryButtonAction()
        }
        .font(Font(UIFont.Theme.regular(ofSize: 14)))
        .accessibilityIdentifier(alertType.primaryButtonAccessibilityId())
    }
    
    private var secondaryActionButton: some View {
        Button {
            presentAlert.toggle()
            secondaryButtonAction()
        } label: {
            Text(alertType.secondaryActionText())
                .foregroundColor(Color(uiColor: UIColor.Theme.defaultTextColor))
                .font(Font(UIFont.Theme.regular(ofSize: 10)))
                .underline()
        }
        .accessibilityIdentifier(alertType.secondaryButtonAccessibilityId())
    }
}

struct CongratsModal: View {
    
    @Binding var isPresented: Bool
    
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
                    isPresented.toggle()
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
            isPresented.toggle()
        }
        .font(Font(UIFont.Theme.regular(ofSize: 14)))
        .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.congratsFinishButton)
    }
    
    private var skipButton: some View {
        Button {
            isPresented.toggle()
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
        CongratsModal(isPresented: .constant(false))
    }
}
