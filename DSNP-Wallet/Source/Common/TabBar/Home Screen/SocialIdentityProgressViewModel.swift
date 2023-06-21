//
//  SocialIdentityProgressViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/21/23.
//

import UIKit
import SwiftUI

class SocialIdentityViewModel: ObservableObject {
    @Published var totalStepsCount: Int = SocialIdentityProgressState.numberOfSteps

    var progress: CGFloat {
        let stepsAchieved = AppState.shared.socialIdentityProgressState()?.totalStepsAchieved() ?? 0
        return CGFloat(stepsAchieved) / CGFloat(totalStepsCount)
    }
    
    var stepsAchieved: Int {
        return AppState.shared.socialIdentityProgressState()?.totalStepsAchieved() ?? 0
    }

    func isAvatarCreated() -> Bool {
        let avatarCreated = AppState.shared.socialIdentityProgressState()?.isAvatarCreated ?? false
        print("avatar created: ", avatarCreated)
        return avatarCreated
    }

    func isHandleChosen() -> Bool {
        let handleChosen = AppState.shared.socialIdentityProgressState()?.isHandleCreated ?? false
        print("handle chosen: ", handleChosen)
        return handleChosen
    }
    
    func isSeedBackedUp() -> Bool {
        let seedBacked = AppState.shared.socialIdentityProgressState()?.isSeedPhraseBacked ?? false
        print("seed backed up: ", seedBacked)
        return seedBacked
    }

}
