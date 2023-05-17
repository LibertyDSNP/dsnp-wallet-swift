//
//  SeedPuzzleViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/15/23.
//

import UIKit
import Combine

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

    let correctPuzzleElements: [PuzzleElement]
    var inColumnPuzzleElements = [PuzzleElement]()
    var inWordBankPuzzleElements: [PuzzleElement]

    private var gameState = [[1, 1, 1], [1, 1, 1], [1, 1, 1]]
    
    private var puzzleItems = [Int: PuzzleElement]()
    
    @Published var attemptedPuzzleElements = [PuzzleElement]()

    @Published var columnOneElements = [PuzzleElement]()
    @Published var columnTwoElements = [PuzzleElement]()

//    var columnOneElements: [PuzzleElement] {
//        if attemptedPuzzleElements.count < 7 {
//            return attemptedPuzzleElements
//        } else {
//            return Array(attemptedPuzzleElements.prefix(6))
//        }
//    }
//
//    var columnTwoElements: [PuzzleElement] {
//        if attemptedPuzzleElements.count < 7 {
//            return []
//        } else {
//            let numElements = attemptedPuzzleElements.count - 6
//            return Array(attemptedPuzzleElements.suffix(numElements))
//        }
//    }
    
    
    var cancellables = [AnyCancellable]()
    
    var isComplete: Bool {
        for i in 0..<correctPuzzleElements.count {
            let element = correctPuzzleElements[i]
            
            if attemptedPuzzleElements.firstIndex(where: { $0.index == element.index && $0.word == element.word }) != nil {
                // we're good
            } else {
                return false
            }
        }
        
        return true
    }
    
    init(correctPuzzleElements: [PuzzleElement]) {
        self.correctPuzzleElements = correctPuzzleElements
        self.inWordBankPuzzleElements = correctPuzzleElements
        setupObservables()
    }
    
    private func setupObservables() {
        selectWordAction
            .receive(on: RunLoop.main)
            .sink { [weak self] element in
                guard let self else { return }
                
                // update game state
                
                self.puzzleItems[self.attemptedPuzzleElements.count] = element
                
                self.attemptedPuzzleElements.append(element)
                
                
                self.inWordBankPuzzleElements = self.inWordBankPuzzleElements.filter { $0 != element }
            }
            .store(in: &cancellables)
        deselectWordAction
            .receive(on: RunLoop.main)
            .sink { [weak self] index in
                guard let self else { return }
                
                guard let element = self.puzzleItems[index] else { return }
                
                // update game state
                print("puzzle before", self.puzzleItems)
                self.puzzleItems = self.puzzleItems.filter({ $0.value != element })
                print("puzzle after", self.puzzleItems)

                self.attemptedPuzzleElements = self.attemptedPuzzleElements.filter { $0 != element }
                self.inWordBankPuzzleElements.append(element)
                
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
