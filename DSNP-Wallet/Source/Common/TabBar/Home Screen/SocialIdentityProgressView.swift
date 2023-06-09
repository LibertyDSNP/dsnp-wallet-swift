//
//  SocialIdentityProgressView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/8/23.
//

import SwiftUI


struct ProgressAnimation: View {
    @State private var drawingWidth = false
    
    let title: String
    
    @ObservedObject var viewModel: SocialIdentityViewModel

    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Font(UIFont.Theme.spaceBold(ofSize: 14)))
                .foregroundColor(.white)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(uiColor: UIColor.Theme.progressBarGray))
                RoundedRectangle(cornerRadius: 15)
                    .fill(mainTeal)
                    .frame(width: drawingWidth ? 250 : 0, alignment: .leading)
                                            .animation(.easeInOut(duration: 10).repeatForever(autoreverses: false), value: drawingWidth)
            }
            .frame(width: 250, height: 12)
            .onAppear {
                drawingWidth.toggle()
            }
        }
    }
}

struct AmpProgressViewStyle: ProgressViewStyle {
    let color: Color = mainTeal
    let height: Double
    var labelFontStyle: Font = Font(UIFont.Theme.spaceBold(ofSize: 14))

    func makeBody(configuration: Configuration) -> some View {
        
        let progress = configuration.fractionCompleted ?? 0.0
        
        GeometryReader { geometry in
            
            VStack(alignment: .leading) {
                
                configuration.label
                    .font(labelFontStyle)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(color)
                            .frame(width: geometry.size.width * progress)
                            .overlay {
                                if let currentValueLabel = configuration.currentValueLabel {
                                    currentValueLabel
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                            }
                    }
            }
        }
    }
}


class SocialIdentityViewModel: ObservableObject {
    @Published var totalStepsCount: Int = 5
    @Published var totalStepsAchieved: Int = 1
}

struct SocialIdentityProgressView: View {
    
    @ObservedObject var viewModel: SocialIdentityViewModel
    
    var body: some View {
        VStack {
            ProgressView("% Social Identity Progress", value: 1, total: 5)
                .progressViewStyle(.linear)
                .tint(mainTeal)
                .foregroundColor(.white)
                .progressViewStyle(AmpProgressViewStyle(height: 100.0))
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
