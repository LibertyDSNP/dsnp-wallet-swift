//
//  TermsView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 7/12/23.
//

import SwiftUI

struct TermsView: View {
    
    @State var agreeDisabled = true
    
    var body: some View {
        VStack {
            ScrollView {
                title
                    .padding(.bottom, 20)
                termsText
                    .padding(20)
            }
            .padding(.top, 70)
            .background(Color(uiColor: UIColor.Theme.bgGray))
            .cornerRadius(30)
            .ignoresSafeArea()
            agreeContainer
        }
    }
    
    var termsText: some View {
        Text(agreeToTermsString)
            .multilineTextAlignment(.leading)
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
    }
    
    var title: some View {
        Text("Amplica Access Terms of Service")
            .font(Font(UIFont.Theme.regular(ofSize: 20)))
            .foregroundColor(.black)
    }
    
    var agreeContainer: some View {
        VStack {
            Button("Agree") {
                // Agree Action
            }
            .background(Color(uiColor: UIColor.Theme.bgGray))
            .disabled(agreeDisabled)
        }
        .background(Color.black)
    }
}


struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
