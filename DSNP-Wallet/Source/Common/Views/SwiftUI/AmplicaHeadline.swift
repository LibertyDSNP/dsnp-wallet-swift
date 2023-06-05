//
//  AmplicaHeadline.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/5/23.
//

import SwiftUI

struct AmplicaHeadline: View {

    var withBackButton: Bool = false
    var backAction: () -> ()?
    
    private let indentationWidth: CGFloat = 18.0
    
    var body: some View {
        HStack(alignment: .top) {
            if withBackButton {
                BackButton {
                    backAction()
                }
                .padding(.leading, indentationWidth)
                .padding(.top, 12)
                Spacer()
                AmplicaLogo()
                    .padding(.trailing, indentationWidth)
                Spacer()
                EmptyView()
            } else {
                AmplicaLogo()
            }
        }
    }
}
struct AmplicaHeadline_Previews: PreviewProvider {
    static var previews: some View {
        AmplicaHeadline()
    }
}
