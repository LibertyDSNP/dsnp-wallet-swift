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

    private var validCharSet = CharacterSet(charactersIn: "1234567890:.")
    
    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        // Monitoring user text input, filter for WS URL related vals
        $wsURLText
            .receive(on: RunLoop.main)
            .sink { [weak self] inputText in
                guard let self else { return }
                //check if the new string contains any invalid characters
                if inputText.rangeOfCharacter(from: self.validCharSet.inverted) != nil {
                    self.wsURLText = String(self.wsURLText.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                }
            }
            .store(in: &cancellables)
        
        // Submit
        submitAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                
                // Can't submit empty string
                if self.wsURLText.isEmpty { return }
                
                ChainEnvironment.setNodeURL(url: "ws://\(self.wsURLText)")
                self.resetFields()
            }
            .store(in: &cancellables)
        
        // Reset
        resetAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                ChainEnvironment.resetNodeURL()
                self.resetFields()
            }
            .store(in: &cancellables)
    }
    
    private func resetFields() {
        currentWsUrl = ChainEnvironment.getNodeURL()
        wsURLText = ""
    }
}
