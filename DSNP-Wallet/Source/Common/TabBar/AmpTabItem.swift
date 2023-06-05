//
//  AmpTabItem.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/1/23.
//

import SwiftUI

struct AmpTabItem: View {
    
    let title: String
    let tabImageName: String
    
    var body: some View {
        VStack {
            Text(title)
            Image(tabImageName)
                .renderingMode(.template)
                .foregroundColor(mainTeal)
                .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
        }
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct AmpTabItem_Previews: PreviewProvider {
    static var previews: some View {
        AmpTabItem(title: "Home", tabImageName: "home")
    }
}
