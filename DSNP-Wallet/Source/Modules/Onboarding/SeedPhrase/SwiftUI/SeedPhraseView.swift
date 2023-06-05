//
//  SeedPhraseView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/12/23.
//

import SwiftUI

struct SeedPhraseView: View {
    
    let viewModel: SeedPhraseViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            title
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            headline
                .padding(.top, 80)
                .padding(.horizontal, 20)
            headlineSubtitle
                .padding(.horizontal, 20)
            testHeadline
                .padding(.horizontal, 20)
            testDescription
                .padding(.horizontal, 20)
            confirmText
                .padding(.horizontal, 16)
            SeedView(viewModel: viewModel)
            writtenDownButton
            Spacer()
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
    
    private var title: some View {
        Text("Recovery Phrase")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.regular(ofSize: 14)))
            .frame(alignment: .center)
    }
    
    private var headline: some View {
        Text("Security is important")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.bold(ofSize: 22)))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
    
    private var headlineSubtitle: some View {
        Text("Back up your recovery phrase now to ensure that your assets will be stores safely and securely")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .padding(.horizontal, 16)
    }
    
    private var testDescription: some View {
        Text("Please carefully write down these 12 words below in numerical order (1-12) and store your secret phrase securely. You will confirm them in order on the next screen.")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
    
    private var testHeadline: some View {
        Text("There will be a test")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.bold(ofSize: 22)))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
    
    private var confirmText: some View {
        HStack {
            Text("You will confirm them ")
                .foregroundColor(.white)
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .padding(.horizontal, -8)
            Text("in order")
                .foregroundColor(Color(uiColor: UIColor.Theme.textOrange))
                .font(Font(UIFont.Theme.bold(ofSize: 12)))
                .frame(alignment: .leading)
            Text(" on the next screen")
                .foregroundColor(.white)
                .font(Font(UIFont.Theme.regular(ofSize: 12)))
                .padding(.horizontal, -8)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 8)
    }
    
    private var writtenDownButton: some View {
        PrimaryButton(title: "I've written it down") {
            viewModel.testAction.send()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .accessibilityIdentifier(AccessibilityIdentifier.SeedPhraseIdentifier.seedPhraseListWrittenButton)
    }
    
}

struct SeedView: View {
    
    let viewModel: SeedPhraseViewModel
    
    var body: some View {
        HStack {
            SeedPhraseColumnView(isColOne: true, viewModel: viewModel)
            SeedPhraseColumnView(isColOne: false, viewModel: viewModel)
        }
        .padding(.leading, 30)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct SeedPhraseColumnView: View {
    let isColOne: Bool
    let viewModel: SeedPhraseViewModel
    
    var body: some View {
        VStack {
            ForEach(isColOne ? 0...5 : 6...11, id: \.self) { index in
                Text("\(SeedPhraseHelper.textForIndex(index: index)) \(viewModel.seedPhraseWords[index])")
                    .foregroundColor(.white)
                    .font(Font(UIFont.Theme.spaceRegular(ofSize: 15)))
                    .frame(minWidth: 0, maxWidth: 120, minHeight: 0, maxHeight: 20, alignment: .leading)
            }
        }
        .accessibilityIdentifier(isColOne ? AccessibilityIdentifier.SeedPhraseIdentifier.seedPhraseListIdentifierA : AccessibilityIdentifier.SeedPhraseIdentifier.seedPhraseListIdentifierB)
    }
}

struct SeedPhraseView_Previews: PreviewProvider {
    static var previews: some View {
        SeedPhraseView(viewModel: SeedPhraseViewModel(seedPhraseWords: ["Hello", "Foo", "bar", "beavis", "butthead","Hello", "Foo", "bar", "beavis", "butthead"]))
    }
}
