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
    
    let correctPuzzleElements: [PuzzleElement]
    var attemptedPuzzleElements = [PuzzleElement]()

    var columnOneElements: [PuzzleElement] {
        if attemptedPuzzleElements.count < 7 {
            return attemptedPuzzleElements
        } else {
            return Array(attemptedPuzzleElements.prefix(6))
        }
    }
    
    var columnTwoElements: [PuzzleElement] {
        if attemptedPuzzleElements.count < 7 {
            return []
        } else {
            let numElements = attemptedPuzzleElements.count - 6
            return Array(attemptedPuzzleElements.suffix(numElements))
        }
    }
    
    
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
    }
    
    private func setupObservables() {
        selectWordAction
            .receive(on: RunLoop.main)
            .sink { [weak self] element in
                guard let self else { return }
                self.attemptedPuzzleElements.append(element)
            }
            .store(in: &cancellables)
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
