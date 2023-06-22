//
//  SocialIdentityProgressViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/21/23.
//

import UIKit
import Combine

class SocialIdentityViewModel: ObservableObject {

    let totalStepsCount: CGFloat = AppState.socialIdentityStepCount

    private var cancellables = [AnyCancellable]()
    
    @Published var progress: CGFloat = {
        let stepsAchieved = AppState.shared.socialIdentityProgressStepsCompleted()
        let prog = CGFloat(stepsAchieved) / AppState.socialIdentityStepCount
        print("progress: \(prog), steps achieved: \(stepsAchieved)")
        return prog
    }()
    
    @Published var stepsAchieved: Int = AppState.shared.socialIdentityProgressStepsCompleted()

    @Published var isSeedBackedUp = AppState.shared.didBackupSeedPhrase()
    @Published var didCreateAvatar = AppState.shared.didCreateAvatar()
    
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
                print("steps increment")
                self.stepsAchieved = AppState.shared.socialIdentityProgressStepsCompleted()
            }
            .store(in: &cancellables)
    }

    func isHandleChosen() -> Bool {
        let handleChosen = !AppState.shared.handle.isEmpty
        return handleChosen
    }

}
