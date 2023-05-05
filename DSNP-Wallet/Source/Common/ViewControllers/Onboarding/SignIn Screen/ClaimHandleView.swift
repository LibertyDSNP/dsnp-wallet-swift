//
//  ClaimHandleView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/5/23.
//

import SwiftUI

struct ClaimHandleView: View {
    @ObservedObject var viewModel: ClaimHandleViewModel
    
    var body: some View {
        VStack {
            AmplicaLogo()
            BaseRoundView {
                Text("Here")
                Text("Here")
                Text("Here")
                Text("Here")
                Text("Here")
                Text("Here")
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
    
    private var stepCount: some View {
        Text("1 of 3")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
    }
    
    private var subtitle: some View {
        Text("Create your Digital Identity")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
    }
    
    private var description: some View {
        Text("Your unique handle is how others will find you across\nthe social web and will be universal across apps.")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
    }
    
    private var textfield: some View {
        VStack {
            Text("Claim your handle")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.black)
            TextField("", text: $viewModel.claimHandleText)
        }
    }
}

struct ClaimHandleView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimHandleView(viewModel: ClaimHandleViewModel())
    }
}
