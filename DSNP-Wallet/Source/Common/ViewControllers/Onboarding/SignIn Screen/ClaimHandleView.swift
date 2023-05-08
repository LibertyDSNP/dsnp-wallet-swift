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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                subtitle
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                description
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                textfield
                    .padding(.horizontal, 10)
                handleDescription
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                buttonStack
                    .padding(.horizontal, 10)
            }
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var stepCount: some View {
        Text("1 of 3")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
    }
    
    private var subtitle: some View {
        Text("Create your Digital Identity")
            .font(Font(UIFont.Theme.semibold(ofSize: 12)))
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
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("", text: $viewModel.claimHandleText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .foregroundColor(.black)
                .padding()
                .background(RoundedRectangle(cornerRadius: 30).fill(Color.white))
        }
    }
    
    private var handleDescription: some View {
        Text("Handle must be between 4-16 characters & can only\nconsist of letters, numbers, and underscores.")
            .font(Font(UIFont.Theme.thin(ofSize: 12)))
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
