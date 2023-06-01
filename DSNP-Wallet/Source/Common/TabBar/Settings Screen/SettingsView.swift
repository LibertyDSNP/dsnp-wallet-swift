//
//  SettingsView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/1/23.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    
}


struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
    
    private var logoutButton: some View {
        Button("log out") {
            
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
