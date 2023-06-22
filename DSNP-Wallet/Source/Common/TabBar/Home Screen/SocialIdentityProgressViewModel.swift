//
//  SocialIdentityProgressViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/21/23.
//

import UIKit
import SwiftUI

class SocialIdentityViewModel: ObservableObject {

    let totalStepsCount: Int = AppState.shared.socialIdentityStepCount

    @Published var progress: CGFloat = {
        let stepsAchieved = AppState.shared.socialIdentityProgressStepsCompleted()
        return CGFloat(stepsAchieved) / CGFloat(AppState.shared.socialIdentityStepCount)
    }()
    
    @Published var stepsAchieved: Int = {
        return AppState.shared.socialIdentityProgressStepsCompleted()
    }()

    func isAvatarCreated() -> Bool {
        let avatarCreated = AppState.shared.didCreateAvatar()
        print("avatar created: ", avatarCreated)
        return avatarCreated
    }

    func isHandleChosen() -> Bool {
        let handleChosen = !AppState.shared.handle.isEmpty
        print("handle chosen: ", handleChosen)
        return handleChosen
    }
    
    func isSeedBackedUp() -> Bool {
        let seedBacked = AppState.shared.didBackupSeedPhrase()
        print("seed backed up: ", seedBacked)
        return seedBacked
    }

}
