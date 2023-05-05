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
                stepCount
                subtitle
                description
                textfield
                handleDescription
                buttonStack
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
    
    private var handleDescription: some View {
        Text("Handle must be between 4-16 characters & can only\nconsist of letters, numbers, and underscores.")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
    }

    private var buttonStack: some View {
        VStack {
            nextButton
            skipButton
        }
    }
    
    private var nextButton: some View {
        PrimaryButton(title: "Next") {
            // TODO: NEXT
        }
    }
    
    private var skipButton: some View {
        Button {
            // TODO SKIP
        } label: {
            Text("Skip for now (not recommended)")
        }
    }
}

struct ClaimHandleView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimHandleView(viewModel: ClaimHandleViewModel())
    }
}
