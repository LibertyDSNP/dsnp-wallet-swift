//
//  AmplicaLogo.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import SwiftUI

struct AmplicaLogo: View {
    var body: some View {
        Image("logo")
            .padding()
    }
}

struct AmplicaLogo_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AmplicaLogo()
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}
