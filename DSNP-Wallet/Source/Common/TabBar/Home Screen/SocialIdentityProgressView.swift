//
//  SocialIdentityProgressView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/8/23.
//

import SwiftUI


struct SocialIdentityProgressBar: View {
    let title: String
    
    
    @AppStorage(AppStateKeys.backedUpSeedPhraseKey.rawValue)
    private var backedUp: Bool = UserDefaults.standard.seedBackedUp

    @AppStorage(AppStateKeys.handle.rawValue)
    private var handle: String = UserDefaults.standard.handle
    
    var stepsAchieved: Int {
        var stepsAchieved = 0
        stepsAchieved += !handle.isEmpty ? 1 : 0
        stepsAchieved += backedUp ? 1 : 0
        stepsAchieved += UserDefaults.standard.didCreateAvatar ? 1 : 0
        return stepsAchieved
    }
    
    var progress: CGFloat {
        var stepsAchieved = 0
        stepsAchieved += !handle.isEmpty ? 1 : 0
        stepsAchieved += backedUp ? 1 : 0
        stepsAchieved += UserDefaults.standard.didCreateAvatar ? 1 : 0
        let prog = CGFloat(stepsAchieved) / 3.0
        return prog
    }

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(Font(UIFont.Theme.spaceBold(ofSize: 14)))
                    .foregroundColor(.white)
                Spacer()
                Text("\(stepsAchieved)/\(3)")
                    .font(Font(UIFont.Theme.spaceBold(ofSize: 14)))
                    .foregroundColor(.white)
            }
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(Color(uiColor: UIColor.Theme.progressBarGray))
                        .frame(height: 12)
                        .frame(width: geometry.size.width)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(mainTeal)
                                .frame(width: geometry.size.width * progress)
                        }
                }
            }
            .frame(height: 12)
        }
        .padding()
    }
}

struct SocialIdentityProgressView: View {
        
    var body: some View {
        VStack {
            SocialIdentityProgressBar(title: "% Social Identity Progress")
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .padding()
    }
}

struct SocialIdentityProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SocialIdentityProgressView()
    }
}
