//
//  SeedPhraseView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/12/23.
//

import SwiftUI

struct SeedPhraseView: View {
    
    let viewModel: SeedPhraseViewModel
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            title
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
            Text("Recovery Phrase")
                .font(Font(UIFont.Theme.regular(ofSize: 16)))
                .foregroundColor(.white)
                .padding(.leading, -18)
            Spacer()
            EmptyView()
        }
        .padding(.top, 70)
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
        NavigationLink(destination: SeedPhrasePuzzle(viewModel: viewModel.seedPhrasePuzzleModel())) {
            Text("I've written it down")
                .font(Font(UIFont.Theme.bold(ofSize: 15)))
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: UIColor.Theme.primaryTeal))
        .foregroundColor(.white)
        .cornerRadius(30)
        .frame(minHeight: 60)
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
