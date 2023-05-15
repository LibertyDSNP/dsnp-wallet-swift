//
//  SeedPhraseView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/12/23.
//

import SwiftUI

struct SeedPhraseView: View {
    var body: some View {
        VStack {
            headline
            headlineSubtitle
            testHeadline
            testDescription
            confirmText
            SeedView()
            writtenDownButton
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        Text("You will confirm them in order on the next screen")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(alignment: .leading)
    }
    
    private var writtenDownButton: some View {
        Button {
            
        } label: {
            Text("I've written it down")
        }
    }
    
}

struct SeedView: View {
    
    let words: [String] = ["Cat","Dog","Rat","Hamster","Iguana","Newt"]
    
    let columns: [GridItem] =
    Array(repeating: .init(.fixed(12)), count: 2)

    
    var body: some View {
        HStack {
            SeedPhraseColumnView()
            SeedPhraseColumnView()
        }
    }
}

struct SeedPhraseColumnView: View {
    let words: [String] = ["Cat","Dog","Rat","Hamster","Iguana","Newt"]
    
    var body: some View {
        VStack {
            ForEach(words, id: \.self) { word in
                Text(word)
                    .foregroundColor(.white)
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
            }
        }
    }
}

struct SeedPhraseView_Previews: PreviewProvider {
    static var previews: some View {
        SeedPhraseView()
    }
}
