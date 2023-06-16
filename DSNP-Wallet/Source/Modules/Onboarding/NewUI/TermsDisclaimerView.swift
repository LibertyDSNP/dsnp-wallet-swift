//
//  TermsDisclaimerView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/24/23.
//

import SwiftUI

struct TermsDisclaimerView: View {

    var color: Color = Color(uiColor: UIColor.Theme.termsTextColor)

    var body: some View {
        VStack {
            Text("By signing up, you agree to Amplica Access")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(color)
                .lineSpacing(3)
                .frame(maxHeight: .infinity, alignment: .bottom)
            if #available(iOS 16.0, *) {
                HStack {
                    
                    Text("[Terms](https://google.com)")
                        .accentColor(color)
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .underline()
                        .padding(.horizontal, -4)
                    Text("and")
                        .accentColor(color)
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .foregroundColor(color)
                    Text("[Privacy Policy](https://google.com)")
                        .accentColor(color)
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .underline()
                        .padding(.horizontal, -4)
                    Text("•")
                        .accentColor(color)
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .foregroundColor(color)
                    Text("[Learn More](https://google.com)")
                        .accentColor(color)
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .underline()
                }
            } else {
                Text("By signing up, you agree to our [Terms](https://google.com) and\n[Privacy Policy](https://google.com) • [Learn More](https://google.com)")
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .foregroundColor(color)
                    .lineSpacing(3)
            }
        }
    }
}

struct SignInTermsDisclaimerView: View {
    var body: some View {
        VStack {
            Text("By signing up, you agree to our")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, -6)
            if #available(iOS 16.0, *) {
                HStack {
                    Text("[Terms](https://google.com)")
                        .accentColor(Color(uiColor: UIColor.Theme.linkOrange))
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .padding(.horizontal, -4)
                    Text("and")
                        .accentColor(Color(uiColor: UIColor.Theme.termsTextColor))
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .foregroundColor(.white)
                    Text("[Privacy Policy](https://google.com)")
                        .accentColor(Color(uiColor: UIColor.Theme.linkOrange))
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .padding(.horizontal, -4)
                }
            } else {
                Text("By signing up, you agree to our [Terms](https://google.com) and\n[Privacy Policy](https://google.com)")
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .foregroundColor(.black)
                    .lineSpacing(3)
            }
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}


struct TermsDisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TermsDisclaimerView()
            SignInTermsDisclaimerView()
        }
    }
}
