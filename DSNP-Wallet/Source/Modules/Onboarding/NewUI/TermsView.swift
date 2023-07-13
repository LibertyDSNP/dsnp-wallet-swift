//
//  TermsView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 7/12/23.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct TermsView: View {
    
    @State var agreeDisabled = true
    
    var body: some View {
        VStack {
            ScrollView {
                title
                    .padding(.bottom, 20)
                termsText
                    .padding(28)
            }
            .padding(.top, 70)
            .padding(.bottom, 16)
            .background(Color(uiColor: UIColor.Theme.bgGray))
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .ignoresSafeArea()
            agreeContainer
        }
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
                
            }
            .disabled(agreeDisabled)
            .padding(.horizontal, 28)
            .padding(.vertical, 20)
            .accessibilityIdentifier(AccessibilityIdentifier.OnboardingIdentifiers.agreeToTermsButton)
            Text("By clicking the agree button you agree")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))

        }
        .background(Color(uiColor: UIColor.Theme.bgGray))
        .padding(.top, -10)
    }
}


struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
