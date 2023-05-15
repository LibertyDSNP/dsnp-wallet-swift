//
//  SeedPuzzleViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/15/23.
//

import UIKit

struct PuzzleElement {
    let word: String
    let index: Int
    
    func == (lhs: PuzzleElement, rhs: PuzzleElement) -> Bool {
        return lhs.index == rhs.index && lhs.word == rhs.word
    }
}

class SeedPuzzleViewModel: ObservableObject {
    
    let correctPuzzleElements: [PuzzleElement]
    
    var attemptedPuzzleElements = [PuzzleElement]()
    
    var isComplete: Bool {
        for i in 0..<correctPuzzleElements.count {
            let element = correctPuzzleElements[i]
            if !attemptedPuzzleElements.contains(element) {
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
