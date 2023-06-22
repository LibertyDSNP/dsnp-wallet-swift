//
//  SocialIdentityProgressViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/21/23.
//

import UIKit
import Combine

class SocialIdentityViewModel: ObservableObject {

    let totalStepsCount: Int = AppState.shared.socialIdentityStepCount

    private var cancellables = [AnyCancellable]()
    
    @Published var progress: CGFloat = {
        let stepsAchieved = AppState.shared.socialIdentityProgressStepsCompleted()
        return CGFloat(stepsAchieved) / CGFloat(AppState.shared.socialIdentityStepCount)
    }()
    
    @Published var stepsAchieved: Int = {
        return AppState.shared.socialIdentityProgressStepsCompleted()
    }()

    @Published var isSeedBackedUp = AppState.shared.didBackupSeedPhrase()
    @Published var didCreateAvatar = AppState.shared.didCreateAvatar()
    
    init(progress: CGFloat, stepsAchieved: Int) {
        self.progress = progress
        self.stepsAchieved = stepsAchieved
        setupObservables()
    }
    
    private func setupObservables() {
        UserDefaults.standard
            .publisher(for: \.seedBackedUp)
            .handleEvents(receiveOutput: { [weak self] seedBackedUp in
                guard let self else { return }
                self.isSeedBackedUp = seedBackedUp
            })
            .sink { _ in }
            .store(in: &cancellables)
        UserDefaults.standard
            .publisher(for: \.didCreateAvatar)
            .handleEvents(receiveOutput: { [weak self] didCreateAvatar in
                guard let self else { return }
                self.didCreateAvatar = didCreateAvatar
            })
            .sink { _ in }
            .store(in: &cancellables)
    }

    func isHandleChosen() -> Bool {
        let handleChosen = !AppState.shared.handle.isEmpty
        print("handle chosen: ", handleChosen)
        return handleChosen
    }

}
