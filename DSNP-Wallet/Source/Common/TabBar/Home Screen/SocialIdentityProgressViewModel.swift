//
//  SocialIdentityProgressViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/21/23.
//

import UIKit
import SwiftUI

class SocialIdentityViewModel: ObservableObject {

    let totalStepsCount: Int = SocialIdentityProgressState.numberOfSteps

    @Published var progress: CGFloat = {
        let stepsAchieved = AppState.shared.socialIdentityProgressState.totalStepsAchieved()
        return CGFloat(stepsAchieved) / CGFloat(SocialIdentityProgressState.numberOfSteps)
    }()
    
    @Published var stepsAchieved: Int = {
        return AppState.shared.socialIdentityProgressStepsCompleted()
    }()

    func isAvatarCreated() -> Bool {
        let avatarCreated = AppState.shared.socialIdentityProgressState.isAvatarCreated
        print("avatar created: ", avatarCreated)
        return avatarCreated
    }

    func isHandleChosen() -> Bool {
        let handleChosen = AppState.shared.socialIdentityProgressState.isHandleCreated
        print("handle chosen: ", handleChosen)
        return handleChosen
    }
    
    func isSeedBackedUp() -> Bool {
        let seedBacked = AppState.shared.socialIdentityProgressState.isSeedPhraseBacked
        print("seed backed up: ", seedBacked)
        return seedBacked
    }

}
