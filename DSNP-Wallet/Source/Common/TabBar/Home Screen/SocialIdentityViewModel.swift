//
//  SocialIdentityViewModel.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 7/7/23.
//

import Combine
import UIKit

class SocialIdentityViewModel: ObservableObject {

    let totalStepsCount: Int = 3
    
    @Published var progress: CGFloat = {
        let stepsAchieved = AppState.shared.socialIdentityProgressStepsCompleted()
        let prog = CGFloat(stepsAchieved) / 3.0
        print("progress: \(prog), steps achieved: \(stepsAchieved)")
        return prog
    }()
    
    @Published var stepsAchieved: Int = AppState.shared.socialIdentityProgressStepsCompleted()
}
