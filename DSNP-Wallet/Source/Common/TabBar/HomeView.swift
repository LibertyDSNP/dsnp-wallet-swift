//
//  HomeView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import SwiftUI

let mainTeal = Color(uiColor: UIColor.Theme.primaryTeal)

struct HomeTabView: View {
    
    let viewModel: HomeViewModel
    
    @State private var tabViewSelection = 0
    @State var showingAlert = false
    
    var body: some View {
        TabView(selection: $tabViewSelection) {
            AMPProfileView(viewModel: AMPHomeViewModel(), showingAlert: showingAlert)
                .tabItem {
                    AmpTabItem(title: "Home", tabImageName: "home")
                }
                .tag(0)
            ProfileView()
                .tabItem {
                    AmpTabItem(title: "Profile", tabImageName: "profile")
                    
                }
                .tag(1)
            PermissionsView()
                .tabItem {
                    AmpTabItem(title: "Permissions", tabImageName: "permissions")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    AmpTabItem(title: "Settings", tabImageName: "settings")
                }
                .tag(3)
        }
        .accentColor(mainTeal)
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(viewModel: HomeViewModel())
    }
}
