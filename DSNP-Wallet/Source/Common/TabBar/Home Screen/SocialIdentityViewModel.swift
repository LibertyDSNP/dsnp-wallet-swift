//
//  SocialIdentityViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 7/7/23.
//

import Combine
import UIKit

class SocialIdentityViewModel: ObservableObject {

    let totalStepsCount: CGFloat = 3

    private var cancellables = [AnyCancellable]()
    
    @Published var progress: CGFloat = {
        let stepsAchieved = AppState.shared.socialIdentityProgressStepsCompleted()
        let prog = CGFloat(stepsAchieved) / 3.0
        print("progress: \(prog), steps achieved: \(stepsAchieved)")
        return prog
    }()
    
    @Published var stepsAchieved: Int = AppState.shared.socialIdentityProgressStepsCompleted()

    @Published var isSeedBackedUp = AppState.shared.didBackupSeedPhrase()
    @Published var isHandleChosen = !AppState.shared.handle.isEmpty
    @Published var didCreateAvatar = UserDefaults.standard.didCreateAvatar
    
    init() {
        setupObservables()
        printVars()
    }
    
    func printVars() {
        print("seed backed up: ", isSeedBackedUp)
        print("created avatar: ", didCreateAvatar)
        print("steps achieved: ", stepsAchieved)
        print("steps count: ", totalStepsCount)
    }
    
    private func setupObservables() {
        UserDefaults.standard
            .publisher(for: \.seedBackedUp)
            .sink { [weak self] seedBackedUp in
                guard let self else { return }
                self.isSeedBackedUp = seedBackedUp
                print("steps increment")
                self.stepsAchieved = AppState.shared.socialIdentityProgressStepsCompleted()
            }
            .store(in: &cancellables)
        UserDefaults.standard
            .publisher(for: \.didCreateAvatar)
            .sink { [weak self] didCreateAvatar in
                guard let self else { return }
                self.didCreateAvatar = didCreateAvatar
                self.stepsAchieved = AppState.shared.socialIdentityProgressStepsCompleted()
            }
            .store(in: &cancellables)
        // TODO: Listen for set handle changes. As of now there is no way to add a handle post onboarding
    }

}
