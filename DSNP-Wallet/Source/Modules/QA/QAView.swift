//
//  QAView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/1/23.
//

import SwiftUI

struct QAView: View {
    
    @State private var input: String = ""
    
    var body: some View {
        VStack {
            wsInputTextField
            currentWsValue
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(Color.black)
    }
    
    var wsInputTextField: some View {
        TextField("WS Address: ", text: $input)
            .onSubmit {
                // validate format
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .border(.secondary)
            .padding()
    }
    
    var currentWsValue: some View {
        Text(ChainEnvironment.getNodeURL())
            .foregroundColor(.blue)
    }
}

struct QAView_Previews: PreviewProvider {
    static var previews: some View {
        QAView()
    }
}
