//
//  QAViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/1/23.
//

import UIKit
import Combine

class QAViewModel: ObservableObject {

    // Published Vals
    @Published var currentWsUrl = ChainEnvironment.getNodeURL()
    @Published var wsURLText = ""
    
    private var cancellables = [AnyCancellable]()
    
    // Actions
    var submitAction = PassthroughSubject<Void, Never>()
    var resetAction = PassthroughSubject<Void, Never>()

    private var validCharSet = CharacterSet(charactersIn: "1234567890.")
    
    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        // Monitoring user text input, filter for WS URL related vals
        $wsURLText.sink { val in
            //check if the new string contains any invalid characters
            if val.rangeOfCharacter(from: self.validCharSet.inverted) != nil {
                DispatchQueue.main.async {
                    self.wsURLText = String(self.wsURLText.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                }
            }
        }
        .store(in: &cancellables)
        
        // Submit
        submitAction.sink { [weak self] in
            guard let self else { return }
            ChainEnvironment.setNodeURL(url: "ws://\(self.wsURLText)")
            self.currentWsUrl = ChainEnvironment.getNodeURL()
        }
        .store(in: &cancellables)
        
        // Reset
        resetAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
            guard let self else { return }
            ChainEnvironment.resetNodeURL()
            self.currentWsUrl = ChainEnvironment.getNodeURL()
        }
        .store(in: &cancellables)
    }
}
