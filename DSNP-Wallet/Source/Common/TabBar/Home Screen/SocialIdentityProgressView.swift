//
//  SocialIdentityProgressView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/8/23.
//

import SwiftUI


struct ProgressAnimation: View {
    let title: String
    @ObservedObject var viewModel: SocialIdentityViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(Font(UIFont.Theme.spaceBold(ofSize: 14)))
                    .foregroundColor(.white)
                Spacer()
                Text("\(viewModel.totalStepsAchieved)/\(viewModel.totalStepsCount)")
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
                                .frame(width: geometry.size.width * viewModel.progress)
                        }
                }
            }
            .frame(height: 12)
        }
        .padding()
    }
}

class SocialIdentityViewModel: ObservableObject {
    @Published var totalStepsCount: Int = 3
    @Published var totalStepsAchieved: Int = 1
    
    var progress: CGFloat {
        return CGFloat(totalStepsAchieved) / CGFloat(totalStepsCount)
    }
}

struct SocialIdentityProgressView: View {
    
    @ObservedObject var viewModel: SocialIdentityViewModel
    
    var body: some View {
        VStack {
            ProgressAnimation(title: "% Social Identity Progress", viewModel: viewModel)
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .padding()
    }
}

struct SocialIdentityProgressView_Previews: PreviewProvider {
    static var previews: some View {
        SocialIdentityProgressView(viewModel: SocialIdentityViewModel())
    }
}
