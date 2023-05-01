//
//  QAView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/1/23.
//

import SwiftUI

struct QAView: View {

    let bgColor = UIColor(red: 35.0/255.0, green: 35.0/255.0, blue: 47.0/255.0, alpha: 1.0)

    @ObservedObject var viewModel: QAViewModel
    
    var body: some View {
        VStack {
            wsInputTextField
                .padding()
            currentWsValue
            submitWsButton
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(Color(uiColor: bgColor))
    }
    
    var submitWsButton: some View {
        HStack {
            Button{
                viewModel.submitAction.send()
            } label: {
                Text("Submit WS Address")
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color.white))
            }
            Button {
                ChainEnvironment.resetNodeURL()
            } label: {
                Text("Reset WS Address")
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 50).fill(Color.white))
            }
        }
    }
    
    var wsInputTextField: some View {
        HStack {
            Text("ws://")
                .font(Font.system(size: 14))
                .foregroundColor(.white)
            TextField("WS Address", text: $viewModel.wsURLText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
                .foregroundColor(.black)
                .padding()
                .background(RoundedRectangle(cornerRadius: 50).fill(Color.white))
        }
    }
    
    var currentWsValue: some View {
        Text("Current WS Address: \(ChainEnvironment.getNodeURL())")
            .foregroundColor(.blue)
    }
}

struct QAView_Previews: PreviewProvider {
    static var previews: some View {
        QAView(viewModel: QAViewModel())
    }
}
