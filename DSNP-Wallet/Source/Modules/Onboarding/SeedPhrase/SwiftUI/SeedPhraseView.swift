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
        VStack {
            headline
            headlineSubtitle
            testHeadline
            testDescription
            confirmText
            SeedView(viewModel: viewModel)
            writtenDownButton
            Spacer()
        }
        .padding(.top, 80)
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
    
    private var headline: some View {
        Text("Headline goes here")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.bold(ofSize: 22)))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(alignment: .leading)
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
            .frame(alignment: .leading)

    }
    
    private var testHeadline: some View {
        Text("There will be a test")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.bold(ofSize: 22)))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(alignment: .leading)
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
        .padding(.horizontal, 16)
        .padding(.vertical, 8)

    }
    
    private var writtenDownButton: some View {
        PrimaryButton(title: "I've written it down") {
            viewModel.testAction.send()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
    }
    
}

struct SeedView: View {
    
    let viewModel: SeedPhraseViewModel
    
    var body: some View {
        HStack {
            SeedPhraseColumnView(words: viewModel.colOneWords)
            SeedPhraseColumnView(words: viewModel.colTwoWords)
        }
        .padding(.leading, 30)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct SeedPhraseColumnView: View {
    
    let words: [String]
    
    var body: some View {
        VStack {
            ForEach(Array(words.enumerated()), id: \.element) { index, element in
                Text("\(SeedPhraseHelper.textForIndex(index: index)) \(element)")
                    .foregroundColor(.white)
                    .font(Font(UIFont.Theme.spaceRegular(ofSize: 15)))
                    .frame(minWidth: 0, maxWidth: 120, minHeight: 0, maxHeight: 20, alignment: .leading)

            }
        }
    }
}

struct SeedPhraseHelper {
    static func textForIndex(index: Int) -> String {
        switch index {
        case 0:
            return "01"
        case 1:
            return "02"
        case 2:
            return "03"
        case 3:
            return "04"
        case 4:
            return "05"
        case 5:
            return "06"
        case 6:
            return "07"
        case 7:
            return "08"
        case 8:
            return "09"
        case 9:
            return "10"
        case 10:
            return "11"
        case 11:
            return "12"
        default:
            return "00"
        }
    }
}

struct SeedPhraseView_Previews: PreviewProvider {
    static var previews: some View {
        SeedPhraseView(viewModel: SeedPhraseViewModel(seedPhraseWords: ["Hello", "Foo", "bar", "beavis", "butthead","Hello", "Foo", "bar", "beavis", "butthead"]))
    }
}
