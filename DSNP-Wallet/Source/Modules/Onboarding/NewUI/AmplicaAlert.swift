//
//  AmplicaAlert.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import SwiftUI

enum AlertType {
    case congrats
    case logoutAlert
    
    func title() -> String {
        switch self {
        case .congrats:
            return "Congratulations!"
        case .logoutAlert:
            return "Logout"
        }
    }
    
    func message() -> String {
        switch self {
        case .congrats:
            return "For better recommendations and\nto connect with people relevant to you filling\nout your profile is a good first step."
        case .logoutAlert:
            return "This action will result in deleting all accounts from this device. Make sure you have backed up your passphrase before proceeding otherwise you won’t be able to restore your wallet."
        }
    }
    
    func primaryActionText() -> String {
        switch self {
        case .congrats:
            return "Finish Digital Identity"
        case .logoutAlert:
            return "Logout"
        }
    }
    
    func secondaryActionText() -> String {
        switch self {
        case .congrats:
            return ""
        case .logoutAlert:
            return "View recovery phrase"
        }
    }
    
    func closeButtonAccessibilityId() -> String {
        switch self {
        case .congrats:
            return AccessibilityIdentifier.OnboardingIdentifiers.congratsCloseButton
        case .logoutAlert:
            return AccessibilityIdentifier.TabView.SettingsViewIdentifiers.modalCloseButton

        }
    }
    
    func primaryButtonAccessibilityId() -> String {
        switch self {
        case .congrats:
            return AccessibilityIdentifier.OnboardingIdentifiers.congratsCloseButton
        case .logoutAlert:
            return AccessibilityIdentifier.TabView.SettingsViewIdentifiers.logoutButton
        }
    }
    
    func secondaryButtonAccessibilityId() -> String {
        switch self {
        case .congrats:
            return AccessibilityIdentifier.OnboardingIdentifiers.congratsCloseButton
        case .logoutAlert:
            return AccessibilityIdentifier.TabView.SettingsViewIdentifiers.recoveryButton
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
            .background(.white)
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
            .padding(.horizontal, 20)
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
        Button {
            presentAlert.toggle()
            primaryButtonAction()
        } label: {
            Text(alertType.primaryActionText())
                .font(Font(UIFont.Theme.medium(ofSize: 14)))
                .padding(.vertical, 16)
                .padding(.horizontal, 82)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color(uiColor: UIColor.Theme.buttonTeal)))
        }
        .accessibilityIdentifier(alertType.primaryButtonAccessibilityId())
    }
    
    private var secondaryActionButton: some View {
        Button {
            presentAlert.toggle()
            secondaryButtonAction()
        } label: {
            Text(alertType.secondaryActionText())
                .font(Font(UIFont.Theme.medium(ofSize: 14)))
                .padding(.vertical, 16)
                .padding(.horizontal, 30)
                .foregroundColor(Color(uiColor: UIColor.Theme.buttonTeal))
                .background(RoundedRectangle(cornerRadius: 30).fill(.white))
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color(uiColor: UIColor.Theme.buttonTeal))
                }
        }
        .accessibilityIdentifier(alertType.secondaryButtonAccessibilityId())
    }
}


struct Se1condaryButton: View {
    let title: String
    let action: () -> Void
    
    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(Font(UIFont.Theme.bold(ofSize: 15)))
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .foregroundColor(isEnabled ? .white : Color(uiColor: UIColor.Theme.bgTeal))
        }
        .frame(maxWidth: .infinity)
        .background(!isEnabled ? Color(uiColor: UIColor.Theme.bgGray) : Color(uiColor: UIColor.Theme.buttonTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
        .onTapGesture {
            isEnabled ? action() : nil
        }
    }
}

struct AmplicaAlert_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            AmplicaAlert(
                presentAlert: .constant(true),
                alertType: .logoutAlert) {
                    print("primary Action")
                } secondaryButtonAction: {
                    print("secondary Action")
                }
        }
    }
}
