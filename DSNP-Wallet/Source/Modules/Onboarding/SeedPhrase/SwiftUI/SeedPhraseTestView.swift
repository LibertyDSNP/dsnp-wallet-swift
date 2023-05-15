//
//  SeedPhraseTestView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/15/23.
//

import SwiftUI

struct SeedPhraseTestView: View {
    
    let viewModel: SeedPhraseViewModel
    
    var body: some View {
        VStack {
            headline
            headlineSubtitle
            SeedPhrasePuzzle()
            Spacer()
        }
        .padding(.top, 80)
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
    
    private var headline: some View {
        Text("This is the test")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.bold(ofSize: 22)))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(alignment: .leading)
    }
    
    private var headlineSubtitle: some View {
        Text("Tap the words in numerical order (1-12) to verify your recovery phrase")
            .foregroundColor(.white)
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .padding(.horizontal, 16)
    }
}

struct SeedPhrasePuzzle: View {
    var body: some View {
        VStack {
            SeedEmptyPhraseColumnView(viewModel: SeedPuzzleViewModel(puzzleElements: [PuzzleElement(word: "hello", index: 0)]))
        }
    }
    
}

struct SeedEmptyPhraseColumnView: View {
    
    let viewModel: SeedPuzzleViewModel
    
    var body: some View {
        VStack {
            Button {
                // Action
            } label: {
                
            }
            .cornerRadius(40)
            .border(Color(uiColor: UIColor.Theme.buttonOrange), width: 1.5)
        }
    }
}


struct SeedPhraseTestView_Previews: PreviewProvider {
    static var previews: some View {
        SeedPhraseTestView(viewModel: SeedPhraseViewModel(seedPhraseWords: ["Here", "are", "some", "words"]))
    }
}
