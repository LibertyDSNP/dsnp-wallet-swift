//
//  SeedPhraseTestView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/15/23.
//

import SwiftUI

let dummyElements: [PuzzleElement] = [
    PuzzleElement(word: "hello", index: 0),
    PuzzleElement(word: "hello", index: 1),
    PuzzleElement(word: "hello", index: 2),
    PuzzleElement(word: "hello", index: 3),
    PuzzleElement(word: "hello", index: 4),
    PuzzleElement(word: "hello", index: 5),
    PuzzleElement(word: "hello", index: 6),
    PuzzleElement(word: "hello", index: 7),
    PuzzleElement(word: "hello", index: 8),
    PuzzleElement(word: "hello", index: 9),
    PuzzleElement(word: "hello", index: 10),
    PuzzleElement(word: "hello", index: 11)
]


struct SeedPhraseTestView: View {
    
    let viewModel: SeedPhraseViewModel
    
    var body: some View {
        VStack {
            headline
            headlineSubtitle
            SeedPhrasePuzzle()
                .padding(.vertical, 14)
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
        HStack {
            SeedEmptyPhraseColumnView(viewModel: SeedPuzzleViewModel(correctPuzzleElements: dummyElements))
            SeedEmptyPhraseColumnView(viewModel: SeedPuzzleViewModel(correctPuzzleElements: dummyElements))
        }
    }
}

struct SeedPhraseButton: View {
    
    let index: Int
    var filled: Bool = false
    
    var body: some View {
        Button {
            // Action - deselect
        } label: {
            Text("\(index)")
                .foregroundColor(.white)
                .font(Font(UIFont.Theme.spaceBold(ofSize: 15)))
                .frame(minWidth: 100, alignment: .leading)
                .padding(.leading, 8)
        }
        .frame(minWidth: 100)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color(uiColor: UIColor.Theme.buttonOrange))
        )
    }
}

struct SeedPhraseWordBank: View {
    var body: some View {
        VStack {
            
        }
    }
}

struct SeedEmptyPhraseColumnView: View {
    
    let viewModel: SeedPuzzleViewModel
    
    var body: some View {
        VStack {
            ForEach(Array(viewModel.correctPuzzleElements.enumerated()), id: \.element) { index, element in
                SeedPhraseButton(index: index)
                    .padding(.vertical, 1)
                    .padding(.horizontal, 10)
            }
        }
    }
}


struct SeedPhraseTestView_Previews: PreviewProvider {
    static var previews: some View {
        SeedPhraseTestView(viewModel: SeedPhraseViewModel(seedPhraseWords: ["Here", "are", "some", "words", "Here", "are", "some", "words", "Here", "are", "some", "words"]))
    }
}
