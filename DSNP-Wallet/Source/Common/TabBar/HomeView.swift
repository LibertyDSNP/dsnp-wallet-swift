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

struct ProfileView: View {
    
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct SettingsView: View {
    
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct PermissionsView: View {
    
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct AmpTabItem: View {
    
    let title: String
    let tabImageName: String
    
    var body: some View {
        VStack {
            Text(title)
            Image(tabImageName)
                .renderingMode(.template)
                .foregroundColor(mainTeal)
                .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
        }
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(viewModel: HomeViewModel())
    }
}
