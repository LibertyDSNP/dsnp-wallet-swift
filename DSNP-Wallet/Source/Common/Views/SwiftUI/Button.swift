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
    
    var suffixImage: Image? = nil
    
    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(Font(UIFont.Theme.medium(ofSize: 14)))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                if let suffixImage {
                    suffixImage
                        .padding(.bottom, 6)
                        .padding(.leading, -15)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(!isEnabled ? Color(uiColor: UIColor.Theme.disabledTeal) : Color(uiColor: UIColor.Theme.primaryTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
        .onTapGesture {
           isEnabled ? action() : nil
        }
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(Font(UIFont.Theme.bold(ofSize: 15)))
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .foregroundColor(isEnabled ? .white : Color(uiColor: UIColor.Theme.bgTeal))
        }
        .frame(maxWidth: .infinity)
        .background(!isEnabled ? Color(uiColor: UIColor.Theme.bgGray) : Color(uiColor: UIColor.Theme.primaryTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
        .onTapGesture {
            isEnabled ? action() : nil
        }
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
        VStack {
            PrimaryButton(title: "Button", action: {
                print("button press!")
            }, suffixImage: Image("mewelogo"))
            .padding(30)
            PrimaryButton(title: "primary button") {
                print("button press!")
            }
            .padding(30)
            SecondaryButton(title: "Secondary Button") {
                print("button press secondary")
            }
            .padding(30)
            SecondaryButton(title: "Secondary Button - Disabled") {
                print("button press secondary")
            }
            .padding(30)
        }
    }
}
