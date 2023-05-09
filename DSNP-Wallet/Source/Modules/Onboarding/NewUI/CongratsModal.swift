//
//  CongratsModal.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import SwiftUI

struct CongratsModal: View {

    let viewModel: CongratsViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                EmptyView()
                Spacer()
                congratsText
                    .padding(.top, 20)
                Spacer()
                CloseButton(action: {
                    // Close
                })
                .padding(16)
            }
            description
            buttonStack
        }
        .background(Color(uiColor: UIColor.Theme.bgGray))
        .ignoresSafeArea()
    }
    
    private var congratsText: some View {
        Text("Congratulations!")
            .font(Font(UIFont.Theme.semibold(ofSize: 22)))
            .foregroundColor(Color(uiColor: UIColor.Theme.congratsColor))
    }
    
    private var buttonStack: some View {
        VStack {
            finishButton
                .padding(.horizontal, 30)
            skipButton
        }
        .padding(16)
    }
    
    private var description: some View {
        Text("For better recommendations and\nto connect with people relevant to you filling\nout your profile is a good first step.")
            .font(Font(UIFont.Theme.thin(ofSize: 12)))
            .foregroundColor(.black)
            .lineSpacing(4)
            .padding(.vertical, 14)
    }
    
    private var finishButton: some View {
        PrimaryButton(title: "Finish Digital Identity") {
            viewModel.finishAction.send()
        }
        .font(Font(UIFont.Theme.regular(ofSize: 14)))
    }
    
    private var skipButton: some View {
        Button {
            viewModel.skipAction.send()
        } label: {
            Text("Skip for now (Not Recommended)")
                .foregroundColor(Color(uiColor: UIColor.Theme.defaultTextColor))
                .font(Font(UIFont.Theme.regular(ofSize: 10)))
                .underline()
        }
    }
}

struct CongratsModal_Previews: PreviewProvider {
    static var previews: some View {
        CongratsModal(viewModel: CongratsViewModel())
    }
}
