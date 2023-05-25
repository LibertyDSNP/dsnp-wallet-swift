//
//  TermsDisclaimerView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/24/23.
//

import SwiftUI

struct TermsDisclaimerView: View {
    var body: some View {
        VStack {
            Text("By signing up, you agree to Amplica Access")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(Color(uiColor: UIColor.Theme.termsTextColor))
                .lineSpacing(3)
                .frame(maxHeight: .infinity, alignment: .bottom)
            if #available(iOS 16.0, *) {
                HStack {
                    
                    Text("[Terms](https://google.com)")
                        .accentColor(Color(uiColor: UIColor.Theme.termsTextColor))
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .underline()
                        .padding(.horizontal, -4)
                    Text("and")
                        .accentColor(Color(uiColor: UIColor.Theme.termsTextColor))
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .foregroundColor(Color(uiColor: UIColor.Theme.termsTextColor))
                    Text("[Privacy Policy](https://google.com)")
                        .accentColor(Color(uiColor: UIColor.Theme.termsTextColor))
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .underline()
                        .padding(.horizontal, -4)
                    Text("•")
                        .accentColor(Color(uiColor: UIColor.Theme.termsTextColor))
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .foregroundColor(Color(uiColor: UIColor.Theme.termsTextColor))
                    Text("[Learn More](https://google.com)")
                        .accentColor(Color(uiColor: UIColor.Theme.termsTextColor))
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .underline()
                }
            } else {
                Text("By signing up, you agree to our [Terms](https://google.com) and\n[Privacy Policy](https://google.com) • [Learn More](https://google.com)")
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .foregroundColor(.black)
                    .lineSpacing(3)
            }
        }
    }
}

struct TermsDisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        TermsDisclaimerView()
    }
}
