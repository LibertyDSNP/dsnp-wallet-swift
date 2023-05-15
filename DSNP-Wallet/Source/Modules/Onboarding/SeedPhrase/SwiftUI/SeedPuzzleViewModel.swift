//
//  SeedPuzzleViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/15/23.
//

import UIKit

struct PuzzleElement: Hashable {
    let word: String
    let index: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
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

class SeedPuzzleViewModel: ObservableObject {
    
    let correctPuzzleElements: [PuzzleElement]
    
    var columnOneElements: [PuzzleElement] {
        return correctPuzzleElements.split().first ?? []
    }
    
    var columnTwoElements: [PuzzleElement] {
        return correctPuzzleElements.split().last ?? []
    }
    
    var attemptedPuzzleElements = [PuzzleElement]()
    
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
    
    func fillElement(index: Int, word: String) {
        let element = PuzzleElement(word: word, index: index)
        attemptedPuzzleElements.append(element)
    }
    
}
