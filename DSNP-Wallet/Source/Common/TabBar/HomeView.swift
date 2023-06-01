//
//  HomeView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import SwiftUI

let mainTeal = Color(uiColor: UIColor.Theme.primaryTeal)

struct HomeTabView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    @State var showingAlert = false
    
    var body: some View {
        mainView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    var mainView: some View {
        if viewModel.appStateLoggedIn {
            MainTabView(viewModel: viewModel)
        } else {
            SignInViewControllerWrapper()
        }
    }
}

struct MainTabView: View {
    let viewModel: HomeViewModel
    
    @State var showingAlert = false
    
    var body: some View {
        TabView {
            AMPProfileView(viewModel: AMPHomeViewModel(), showingAlert: showingAlert)
                .tabItem {
                    AmpTabItem(title: "Home", tabImageName: "home")
                }
            ProfileView()
                .tabItem {
                    AmpTabItem(title: "Profile", tabImageName: "profile")
                    
                }
            PermissionsView()
                .tabItem {
                    AmpTabItem(title: "Permissions", tabImageName: "permissions")
                }
            SettingsView(viewModel: viewModel)
                .tabItem {
                    AmpTabItem(title: "Settings", tabImageName: "settings")
                }
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
