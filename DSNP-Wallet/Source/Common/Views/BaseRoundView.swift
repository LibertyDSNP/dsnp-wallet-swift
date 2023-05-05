//
//  BaseRoundView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import SwiftUI

struct BaseRoundView<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(content: content).padding()
        }
        .background(Color(uiColor: UIColor.Theme.bgGray))
        .cornerRadius(30)
        .frame(
            minWidth: .infinity,
            maxHeight: .infinity
        )
    }
}

struct BaseRoundView_Previews: PreviewProvider {
    static var previews: some View {
        BaseRoundView {
            Text("Hello")
        }
    }
}
