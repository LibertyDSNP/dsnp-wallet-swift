//
//  BulletListView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/8/23.
//

import SwiftUI

struct BulletListView: View {
    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var bullet: String = "•"
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: listItemSpacing) {
            ForEach(listItems, id: \.self) { data in
                HStack(alignment: .top) {
                    Text(bullet)
                        .frame(width: bulletWidth,
                               alignment: bulletAlignment)
                    Text(data)
                        .font(Font(UIFont.Theme.regular(ofSize: 12)))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
struct BulletListView_Previews: PreviewProvider {
    static var previews: some View {
        BulletListView(listItems: ["item 1", "item 2"])
    }
}
