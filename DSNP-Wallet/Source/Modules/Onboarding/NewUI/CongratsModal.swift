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
            congratsText
            description
            buttonStack
        }
    }
    
    private var congratsText: some View {
        Text("Congratulations!")
            .font(Font(UIFont.Theme.bold(ofSize: 22)))
            .foregroundColor(Color(uiColor: UIColor.Theme.congratsColor))
    }
    
    private var buttonStack: some View {
        VStack {
            finishButton
            skipButton
        }
    }
    
    private var description: some View {
        Text("For better recommendations and\nto connect with people relevant to you filling\nout your profile is a good first step.")
            .font(Font(UIFont.Theme.regular(ofSize: 22)))
            .foregroundColor(.black)
    }
    
    private var finishButton: some View {
        PrimaryButton(title: "Finish Digital Identitys") {
            viewModel.finishAction.send()
        }
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
