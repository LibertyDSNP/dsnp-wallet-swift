//
//  Button.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/4/23.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    @State var disabled = false
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(Font(UIFont.Theme.medium(ofSize: 14)))
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .background(disabled ? Color(uiColor: UIColor.Theme.disabledTeal) : Color(uiColor: UIColor.Theme.primaryTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
    }
}

struct CloseButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image("close")
        }
        .frame(width: 30, height: 30)
    }
}


struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "primary button") {
            print("button press!")
        }
    }
}
