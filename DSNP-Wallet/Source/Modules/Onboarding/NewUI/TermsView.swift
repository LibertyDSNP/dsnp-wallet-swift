//
//  TermsView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 7/12/23.
//

import SwiftUI

struct TermsView: View {
    
    @AppStorage(AppStateKeys.hasAgreedToTerms.rawValue)
    private var hasAgreedToTerms: Bool = UserDefaults.standard.hasAgreedToTerms
    
    @Environment(\.dismiss) var dismiss
    
    @State private var agreeVisible = false
    
    var body: some View {
        VStack {
            ScrollView {
                title
                termsText
                    .padding(28)
            }
            .onScrolledToBottom {
                agreeVisible = true
            }
            .background(Color(uiColor: UIColor.Theme.bgGray))
            .padding(.bottom, 16)
            .padding(.top, 30)
            agreeContainer
        }
        .cornerRadius(40)
        .background(.clear)
        .ignoresSafeArea()
    }
    
    var modalBar: some View {
        Image("modalBar")
    }
    
    var termsText: some View {
        Text(agreeToTermsString)
            .multilineTextAlignment(.leading)
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.termsText)
    }
    
    var title: some View {
        Text("Amplica Access Terms of Service")
            .font(Font(UIFont.Theme.regular(ofSize: 20)))
            .foregroundColor(.black)
    }
    
    var agreeContainer: some View {
        VStack {
            PrimaryButton(title: "Agree") {
                hasAgreedToTerms = true
                dismiss()
            }
            .disabled(agreeVisible)
            .padding(.horizontal, 28)
            .padding(.vertical, 20)
            .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.agreeToTermsButton)
            Text("By clicking the agree button you agree")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
        }
        .background(Color(uiColor: UIColor.Theme.bgGray))
        .padding(.top, -24)
        .padding(.bottom, 20)
    }
}


struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
            .padding(.top, 70)
    }
}

extension ScrollView {
    func onScrolledToBottom(perform action: @escaping() -> Void) -> some View {
        return ScrollView<LazyVStack> {
            LazyVStack {
                self.content
                Rectangle().size(.zero).onAppear {
                    action()
                }
            }
        }
    }
}
