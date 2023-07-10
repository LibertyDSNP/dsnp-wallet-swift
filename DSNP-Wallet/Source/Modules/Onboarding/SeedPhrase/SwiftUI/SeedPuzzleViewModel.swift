//
//  SeedPuzzleViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/15/23.
//

import UIKit
import Combine
import SwiftUI

struct PuzzleElement: Hashable {
    let word: String
    let index: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}

class SeedPuzzleViewModel: ObservableObject {
    
    // Actions
    let selectWordAction = PassthroughSubject<PuzzleElement, Never>()
    let deselectWordAction = PassthroughSubject<Int, Never>()
    let continueAction = PassthroughSubject<Void, Never>()

    // Game State
    let correctPuzzleElements: [PuzzleElement]
    private(set) var inWordBankPuzzleElements: [PuzzleElement]
    private(set) var shuffledWordBankElements: [PuzzleElement]

    private var puzzleItems = [Int: PuzzleElement]()

    
    // Error Handling
    
    @Published var errorMessage = ""
    @Published var errorMessageColor: Color = Color(uiColor: UIColor.Theme.errorStringColor)

    private var seedphraseAlertString: String {
        let seedphraseWrongString = "You got it wrong!"
        let seedphraseCorrectString = "You passed the test"
        return isPuzzleCorrect() ? seedphraseCorrectString : seedphraseWrongString
    }
    
    // Observed vars
    @Published var continueEnabled: Bool = false
    @Published var attemptedPuzzleElements = [PuzzleElement]()

    var cancellables = [AnyCancellable]()
    
    init(correctPuzzleElements: [PuzzleElement]) {
        self.correctPuzzleElements = correctPuzzleElements
        self.inWordBankPuzzleElements = correctPuzzleElements
        self.shuffledWordBankElements = correctPuzzleElements.shuffled()
        setupObservables()
    }
    
    private func setupObservables() {
        selectWordAction
            .receive(on: RunLoop.main)
            .sink { [weak self] element in
                guard let self else { return }
                
                // update game state

                // Get first empty index, place element there
                self.puzzleItems[self.firstAvailableIndex()] = element
                
                self.attemptedPuzzleElements.append(element)
                
                self.inWordBankPuzzleElements = self.inWordBankPuzzleElements.filter { $0 != element }
                self.continueEnabled = self.isPuzzleComplete()
                self.errorMessage = ""
            }
            .store(in: &cancellables)
        deselectWordAction
            .receive(on: RunLoop.main)
            .sink { [weak self] index in
                guard let self else { return }
                
                guard let element = self.puzzleItems[index] else { return }

                // update game state
                self.puzzleItems = self.puzzleItems.filter({ $0.value != element })
                
                self.continueEnabled = false
                self.attemptedPuzzleElements = self.attemptedPuzzleElements.filter { $0 != element }
                self.inWordBankPuzzleElements.append(element)
                self.errorMessage = ""
            }
            .store(in: &cancellables)
        continueAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                if self.isPuzzleComplete() {
                    self.errorMessage = self.seedphraseAlertString
                    self.errorMessageColor = {
                        let errColor = Color(uiColor: UIColor.Theme.errorStringColor)
                        return self.seedphraseAlertString == "You passed the test" ? .green : errColor
                    }()
                    
                    // Update social ID Progress
                    if self.isPuzzleCorrect() {
                        AppState.shared.setBackedUp(backedUp: true)
                    }
                    
                    self.resetPuzzle()
                }
            }
            .store(in: &cancellables)
    }
    
    func shouldElementBeFilled(for index: Int) -> Bool {
        return puzzleItems[index] != nil
    }
    
    func shouldWordBankElementBeFilled(element: PuzzleElement) -> Bool {
        return !puzzleItems.values.contains(element)
    }
    
    func columnElement(for index: Int) -> PuzzleElement? {
        return puzzleItems[index]
    }
    
    func isPuzzleCorrect() -> Bool {
        guard puzzleItems.count == correctPuzzleElements.count else { return false }
        var isCorrect = true
        puzzleItems.forEach { key, value in
            if key != value.index {
                isCorrect = false
            }
        }
        return isCorrect
    }
    
    func isPuzzleComplete() -> Bool {
        return puzzleItems.count == correctPuzzleElements.count
    }
    
    private func firstAvailableIndex() -> Int {
        for i in 0...correctPuzzleElements.count {
            if puzzleItems[i] == nil {
                return i
            }
        }
        return 0
    }
    
    private func resetPuzzle() {
        inWordBankPuzzleElements = correctPuzzleElements
        puzzleItems = [Int: PuzzleElement]()
        continueEnabled = false
        attemptedPuzzleElements = []
    }
}

extension Array {
    func split() -> [[Element]] {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}
