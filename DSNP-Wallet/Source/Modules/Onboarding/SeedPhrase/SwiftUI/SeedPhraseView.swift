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
            SeedView(words: ["Hello", "Hello2"])
            writtenDownButton
        }
    }
    
    private var headline: some View {
        Text("Headline")
    }
    
    private var headlineSubtitle: some View {
        Text("subtitle")

    }
    
    private var testHeadline: some View {
        Text("test Headline")
    }
    
    private var testDescription: some View {
        Text("test description")
    }
    
    private var confirmText: some View {
        Text("confirm")
    }
    
    private var writtenDownButton: some View {
        Button {
            
        } label: {
            Text("I've written it down")
        }
    }
    
}

struct SeedView: View {
    
    let words: [String]
    
    var body: some View {
        VStack {
            
        }
    }
}

struct SeedPhraseView_Previews: PreviewProvider {
    static var previews: some View {
        SeedPhraseView()
    }
}
