//
//  SeedPhraseViewModel.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/9/23.
//

import Foundation
import Combine

class SeedPhraseViewModel {
    
    let testAction = PassthroughSubject<Void, Never>()
    
    let seedPhraseWords: [String]
    
    var colOneWords: [String] {
        return seedPhraseWords.split().first ?? []
    }
    
    var colTwoWords: [String] {
        return seedPhraseWords.split().last ?? []
    }
    
    init(seedPhraseWords: [String]) {
        self.seedPhraseWords = seedPhraseWords
    }
}

struct SeedPhraseHelper {
    static func textForIndex(index: Int) -> String {
        switch index {
        case 0:
            return "01"
        case 1:
            return "02"
        case 2:
            return "03"
        case 3:
            return "04"
        case 4:
            return "05"
        case 5:
            return "06"
        case 6:
            return "07"
        case 7:
            return "08"
        case 8:
            return "09"
        case 9:
            return "10"
        case 10:
            return "11"
        case 11:
            return "12"
        default:
            return "00"
        }
    }
}
