//
//  AmplicaAlert.swift
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
            return ""
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
        ZStack {
            ZStack {
                Color.black.opacity(0.75)
                    .edgesIgnoringSafeArea(.all)
            }
            VStack(alignment: .center) {
                headline
                messageText
                    .multilineTextAlignment(.center)
                buttonStack
            }
            .background(Color(uiColor: UIColor.Theme.bgGray))
            .cornerRadius(20)
            .padding(16)
        }
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
            .frame(alignment: .center)
    }
    
    private var buttonStack: some View {
        VStack {
            primaryActionButton
                .padding(.horizontal, 30)
            secondaryActionButton
        }
        .padding(20)
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
