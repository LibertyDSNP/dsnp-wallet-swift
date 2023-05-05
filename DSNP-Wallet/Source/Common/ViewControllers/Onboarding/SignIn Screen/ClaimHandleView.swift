//
//  ClaimHandleView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/5/23.
//

import SwiftUI

struct ClaimHandleView: View {
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
}

struct ClaimHandleView_Previews: PreviewProvider {
    static var previews: some View {
        ClaimHandleView()
    }
}
