//
//  ClaimHandleView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/5/23.
//

import SwiftUI

struct ClaimHandleView: View {
    @ObservedObject var viewModel: ClaimHandleViewModel
    
    @FocusState private var textfieldFocused: Bool

    var body: some View {
        VStack {
            AmplicaLogo()
            BaseRoundView {
                stepCount
                subtitle
                description
                textfield
                    .padding(.horizontal, 10)
                handleDescription
                buttonStack
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
            }
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var stepCount: some View {
        Text("1 of 3")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
    }
    
    private var subtitle: some View {
        Text("Create Digital Identity")
            .font(Font(UIFont.Theme.medium(ofSize: 12)))
            .foregroundColor(.black)
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var description: some View {
        Text("Your unique handle is how others will find you across\nthe social web and will be universal across apps.")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
    }
    
    private var textfield: some View {
        VStack {
            Text("Claim your handle")
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 2)
            TextField("", text: $viewModel.claimHandleText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color.white))
                .font(Font(UIFont.Theme.regular(ofSize: 16)))
                .foregroundColor(Color(uiColor: UIColor.Theme.defaultTextColor))
                .focused($textfieldFocused)
        }
    }
    
    private var handleDescription: some View {
        Text("Handle must be between 4-16 characters & can only\nconsist of letters, numbers, and underscores.")
            .font(Font(UIFont.Theme.regular(ofSize: 10)))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
    }

    private var buttonStack: some View {
        VStack {
            nextButton
            skipButton
        }
    }
    
    private var nextButton: some View {
        Button {
            viewModel.nextAction.send()
        } label: {
            Text("Next")
                .font(Font(UIFont.Theme.medium(ofSize: 14)))
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .background($viewModel.nextButtonDisabled.wrappedValue ? Color(uiColor: UIColor.Theme.disabledTeal) : Color(uiColor: UIColor.Theme.primaryTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
        .disabled($viewModel.nextButtonDisabled.wrappedValue)
    }
    
    private var skipButton: some View {
        Button {
            // TODO SKIP
        } label: {
            Text("Skip for now (Not Recommended)")
                .foregroundColor(Color(uiColor: UIColor.Theme.defaultTextColor))
                .font(Font(UIFont.Theme.regular(ofSize: 10)))
                .underline()
        }
    }
}

struct ClaimHandleView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimHandleView(viewModel: ClaimHandleViewModel())
    }
}
