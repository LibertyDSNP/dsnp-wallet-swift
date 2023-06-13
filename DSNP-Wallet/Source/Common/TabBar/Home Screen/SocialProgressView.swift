//
//  SocialProgressView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/13/23.
//

import SwiftUI

struct SocialProgressView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            title
            progressView
            description
            taskIndicatorStack
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .navigationBarHidden(true)

    }
    
    private var title: some View {
        HStack {
            BackButton {
                dismiss()
            }
            .padding(.leading, 18)
            Spacer()
            Text("Social Identity")
                .font(Font(UIFont.Theme.regular(ofSize: 16)))
                .foregroundColor(.white)
                .padding(.leading, -28)
            Spacer()
            EmptyView()
        }
        .padding(.top, 70)
    }
    
    private var progressView: some View {
        SocialIdentityProgressView(viewModel: SocialIdentityViewModel())
    }
    
    private var description: some View {
        Text("In today's rapidly evolving world, your real name is more than a name - it's your true identity, your brand, your calling card and your livelihood. By completing the steps it’ll be good for you...")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .frame(alignment: .center)
            .padding(.horizontal, 30)
    }
    
    private var taskIndicatorStack: some View {
        VStack {
            IdentityProgressItem(title: "Set Avatar", isComplete: false)
            IdentityProgressItem(title: "Backup Seed Phrase", isComplete: false)
            IdentityProgressItem(title: "Choose a handle", isComplete: true)
        }
    }
}

struct IdentityProgressItem: View {
    
    let title: String
    let isComplete: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(!isComplete ? Color(uiColor: UIColor.Theme.bgTeal) : Color(uiColor: UIColor.Theme.errorListItemForegroundColor))
                .font(Font(UIFont.Theme.medium(ofSize: 20)))
                .padding(.vertical, 20)
                .padding(.horizontal, 26)
            Spacer()
            accessoryItem
                .padding(.horizontal, 12)

        }
        .background(RoundedRectangle(cornerRadius: 15).fill(
            !isComplete ?
            Color(uiColor: UIColor.Theme.listItemBackground)
            :
                Color(uiColor: UIColor.Theme.progressBarGray)))
        .padding(.vertical, 4)
        .padding(.horizontal, 28)
    }
    
    @ViewBuilder
    var accessoryItem: some View {
        if isComplete {
            Image("checkmark")
        } else {
            todoItem
        }
    }
    
    var todoItem: some View {
        Text("To Do")
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 5).fill(Color(uiColor: UIColor.Theme.toDoBackground)))
            .foregroundColor(Color(uiColor: UIColor.Theme.toDoButtonText))
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            
    }
}

struct SocialProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SocialProgressView()
    }
}
