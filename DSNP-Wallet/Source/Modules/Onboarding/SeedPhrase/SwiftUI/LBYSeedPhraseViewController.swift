//
//  LBYSeedPhraseViewController.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/16/23.
//

import UIKit
import SwiftUI
import Combine

class LBYSeedPhraseViewController: UIHostingController<SeedPhraseView> {

    let viewModel: SeedPhraseViewModel
    
    private var cancellables = [AnyCancellable]()
    
    init() {
        let seed = SeedManager.shared.fetch() ?? ""
        let words = seed.components(separatedBy: " ")
        self.viewModel = SeedPhraseViewModel(seedPhraseWords: words)

        super.init(rootView: SeedPhraseView(viewModel: self.viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservables()
    }

    private func setupObservables() {
        viewModel.testAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                let puzzleElements = self.viewModel.seedPhraseWords.enumerated().map { (index, element) in
                    return PuzzleElement(word: element, index: index)
                }
                let viewModel = SeedPuzzleViewModel(correctPuzzleElements: puzzleElements)
                self.navigationController?.pushViewController(SeedPhraseTestViewController(viewModel: viewModel), animated: true)
            }
            .store(in: &cancellables)
    }
    
}
