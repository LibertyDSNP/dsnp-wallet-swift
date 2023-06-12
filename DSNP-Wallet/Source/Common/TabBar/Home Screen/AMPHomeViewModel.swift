//
//  AMPHomeViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import UIKit
import Combine

class AMPHomeViewModel: ObservableObject {

    @Published var firstNameText = ""
    @Published var lastNameText = ""
    @Published var emailText = ""

    @Published var isEditing: Bool = false    
    
    @Published var rewardBannerShowing: Bool = true

    
    let rewardAmount: Int = 400
    
    // Actions
    var claimNowAction = PassthroughSubject<Void, Never>()
    
    private var cancellables = [AnyCancellable]()
    
    init() {
        setupObservables()
    }
    
    func toggleEditMode() {
        isEditing.toggle()
    }
    
    private func setupObservables() {
        claimNowAction
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                self.rewardBannerShowing = false
            }
            .store(in: &cancellables)
    }
    
}
