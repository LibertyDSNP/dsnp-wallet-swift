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

class SeedPuzzleViewModel: ObservableObject {
    
    let correctPuzzleElements: [PuzzleElement]
    
    var attemptedPuzzleElements = [PuzzleElement]()
    
    var isComplete: Bool {
        for i in 0..<correctPuzzleElements.count {
            let element = correctPuzzleElements[i]
            
            if let idx = attemptedPuzzleElements.firstIndex(where: { $0.index == element.index && $0.word == element.word }) {
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
