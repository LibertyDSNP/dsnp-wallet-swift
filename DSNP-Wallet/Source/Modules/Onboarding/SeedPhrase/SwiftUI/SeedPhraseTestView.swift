//
//  SeedPhraseTestView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/15/23.
//

import SwiftUI

struct SeedPhraseTestView: View {
    
    @ObservedObject var viewModel: SeedPuzzleViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                title
                    .frame(maxWidth: .infinity, alignment: .center)
                headline
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                headlineSubtitle
                    .padding(.horizontal, 20)
                SeedPhrasePuzzle(viewModel: viewModel)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                errorMessage
                SeedPhraseWordBank(viewModel: viewModel)
                    .padding(.horizontal, 14)
                continueButton
                Spacer()
            }
            .background(Color(uiColor: UIColor.Theme.bgTeal))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
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
        SecondaryButton(title: "Continue") {
            if viewModel.continueEnabled {
                viewModel.continueAction.send()
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 18)
        .accessibilityIdentifier(AccessibilityIdentifier.SeedPhraseTestIdentifier.seedPhraseTestContinueButton)
        .disabled(!viewModel.continueEnabled)
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
                .padding(.leading, -28)
            Spacer()
            EmptyView()
        }
        .padding(.top, 70)
    }
    
    private var errorMessage: some View {
        Text(viewModel.errorMessage)
            .foregroundColor(viewModel.errorMessageColor)
            .font(Font(UIFont.Theme.bold(ofSize: 12)))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 14)
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
            HStack {
                Text("\(SeedPhraseHelper.textForIndex(index: index))")
                    .foregroundColor(.white)
                    .font(Font(UIFont.Theme.spaceBold(ofSize: 15)))
                    .padding(.leading, 8)
                Text(element != nil ? "\(element?.word ?? "")" : "")
                    .foregroundColor(.white)
                    .font(Font(UIFont.Theme.spaceRegular(ofSize: 15)))
            }
            .frame(minWidth: 130, alignment: .leading)
        }
        .frame(minWidth: 130, minHeight: 25)
        .background(element != nil ? Color(uiColor: UIColor.Theme.buttonOrange) : .clear)
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
            ForEach(viewModel.shuffledWordBankElements, id: \.self) { element in
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
                .frame(minWidth: 110, minHeight: 25)
                .background(viewModel.shouldWordBankElementBeFilled(element: element) ? Color(uiColor: UIColor.Theme.buttonOrange) : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color(uiColor: UIColor.Theme.buttonOrange))
                )
                .cornerRadius(40)
            }
        }
        .accessibilityIdentifier(AccessibilityIdentifier.SeedPhraseTestIdentifier.seedPhraseTestWordBank)
    }
}

struct SeedEmptyPhraseColumnView: View {
    
    @ObservedObject var viewModel: SeedPuzzleViewModel
    let isColOne: Bool
    
    var body: some View {
        VStack {
            ForEach(isColOne ? 0...5 : 6...11, id: \.self) { index in
                SeedPhraseButton(index: index, element: viewModel.columnElement(for: index)) {
                    if viewModel.shouldElementBeFilled(for: index) {
                        viewModel.deselectWordAction.send(index)
                    }
                }
                .padding(.vertical, 1)
                .padding(.horizontal, 10)
            }
        }
        .accessibilityIdentifier(isColOne ? AccessibilityIdentifier.SeedPhraseTestIdentifier.seedPhraseTestListIdentifierA : AccessibilityIdentifier.SeedPhraseTestIdentifier.seedPhraseTestListIdentifierB)
    }
}

struct SeedPhraseTestView_Previews: PreviewProvider {

    static var previews: some View {
        let puzzleElements = testWords.enumerated().map { (index, element) in
            return PuzzleElement(word: element, index: index)
        }
        SeedPhraseTestView(viewModel: SeedPuzzleViewModel(correctPuzzleElements: puzzleElements))
    }
}
