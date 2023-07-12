//
//  TermsView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 7/12/23.
//

import SwiftUI

struct TermsView: View {
    var body: some View {
        VStack {
            ScrollView {
                title
                    .padding(.bottom, 20)
                termsText
            }
            agreeContainer
        }
        .padding(.top, 20)
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
        Rectangle()
    }
}


struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
