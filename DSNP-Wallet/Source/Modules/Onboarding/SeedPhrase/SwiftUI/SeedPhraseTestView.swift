//
//  SeedPhraseTestView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/15/23.
//

import SwiftUI

let dummyElements: [PuzzleElement] = [
    PuzzleElement(word: "hello", index: 0),
    PuzzleElement(word: "there", index: 1),
    PuzzleElement(word: "here", index: 2),
    PuzzleElement(word: "is", index: 3),
    PuzzleElement(word: "a", index: 4),
    PuzzleElement(word: "seed", index: 5),
    PuzzleElement(word: "phrase", index: 6),
    PuzzleElement(word: "Ben", index: 7),
    PuzzleElement(word: "is", index: 8),
    PuzzleElement(word: "Cool", index: 9),
    PuzzleElement(word: "Sandwich", index: 10),
    PuzzleElement(word: "Pizza", index: 11)
]


struct SeedPhraseTestView: View {
    
    @ObservedObject var viewModel: SeedPuzzleViewModel
    
    var body: some View {
        VStack {
            headline
            headlineSubtitle
            SeedPhrasePuzzle(viewModel: viewModel)
                .padding(.vertical, 14)
            SeedPhraseWordBank(viewModel: viewModel)
            continueButton
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
    
    private var continueButton: some View {
        SecondaryButton(title: "Continue", enabled: viewModel.continueEnabled) {
            viewModel.continueAction.send()
            print("continue enabled: ", viewModel.continueEnabled)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 18)
    }
}

struct SeedPhrasePuzzle: View {
    
    let viewModel: SeedPuzzleViewModel
    
    var body: some View {
        HStack {
            SeedEmptyPhraseColumnView(viewModel: viewModel, isColOne: true)
            SeedEmptyPhraseColumnView(viewModel: viewModel, isColOne: false)
        }
    }
}

struct SeedPhraseButton: View {
    
    let index: Int
    let element: PuzzleElement?
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(element != nil ? "\(index) \(element?.word ?? "")" : "\(index)")
                .foregroundColor(.white)
                .font(Font(UIFont.Theme.spaceBold(ofSize: 15)))
                .frame(minWidth: 100, alignment: .leading)
                .padding(.leading, 8)
        }
        .background(element != nil ? Color(uiColor: UIColor.Theme.buttonOrange) : .clear)
        .frame(minWidth: 100)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color(uiColor: UIColor.Theme.buttonOrange))
        )
        .cornerRadius(40)
    }
}

struct SeedPhraseWordBank: View {
    
    @ObservedObject var viewModel: SeedPuzzleViewModel
    
    let layout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: layout, spacing: 5) {
            ForEach(viewModel.correctPuzzleElements, id: \.self) { element in
                Button {
                    if viewModel.shouldWordBankElementBeFilled(element: element) {
                        viewModel.selectWordAction.send(element)
                    }
                } label: {
                    Text(viewModel.shouldWordBankElementBeFilled(element: element) ? element.word : "")
                        .foregroundColor(.white)
                        .font(Font(UIFont.Theme.spaceRegular(ofSize: 15)))
                        .frame(minWidth: 100, alignment: .center)
                        .padding(.leading, 8)
                }
                .background(viewModel.shouldWordBankElementBeFilled(element: element) ? Color(uiColor: UIColor.Theme.buttonOrange) : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color(uiColor: UIColor.Theme.buttonOrange))
                )
                .cornerRadius(40)
                .frame(minWidth: 100)
            }
        }
    }
}

struct SeedEmptyPhraseColumnView: View {
    
    @ObservedObject var viewModel: SeedPuzzleViewModel
    let isColOne: Bool
    
    var body: some View {
        VStack {
            ForEach(isColOne ? 0...5 : 6...11, id: \.self) { index in
                SeedPhraseButton(index: index + 1, element: viewModel.columnElement(for: index)) {
                    if viewModel.shouldElementBeFilled(for: index) {
                        viewModel.deselectWordAction.send(index)
                    }
                }
                .padding(.vertical, 1)
                .padding(.horizontal, 10)
            }
        }
    }
}


struct SeedPhraseTestView_Previews: PreviewProvider {
    static var previews: some View {
        SeedPhraseTestView(viewModel: SeedPuzzleViewModel(correctPuzzleElements: dummyElements))
    }
}
