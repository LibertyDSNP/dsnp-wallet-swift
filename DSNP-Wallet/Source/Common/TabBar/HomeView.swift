//
//  HomeView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import SwiftUI

struct HomeTabView: View {
    
    let viewModel: HomeViewModel
    
    @State public var tabViewSelection = 0
    
    @State var showingAlert = false
    
    var body: some View {
        TabView(selection: $tabViewSelection) {
            AMPProfileView(viewModel: AMPHomeViewModel(), showingAlert: showingAlert)
                .tabItem {
                    AmpTabItem(title: "Home", tabImageName: "home", tabSelectedImageName: "home_selected", isSelected: tabViewSelection == 0)
                }
                .tag(0)
            ProfileView()
                .tabItem {
                    AmpTabItem(title: "Profile", tabImageName: "profile", tabSelectedImageName: "profile_selected", isSelected: tabViewSelection == 1)                }
                .tag(1)
            PermissionsView()
                .tabItem {
                    AmpTabItem(title: "permissions", tabImageName: "permissions", tabSelectedImageName: "permissions_selected", isSelected: tabViewSelection == 2)
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    AmpTabItem(title: "Settings", tabImageName: "settings", tabSelectedImageName:  "settings_selected", isSelected: tabViewSelection == 3)
                }
                .tag(3)
        }
        .accentColor(Color(uiColor: UIColor.Theme.primaryTeal))
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
    let tabSelectedImageName: String
    
    @State var isSelected: Bool = false
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(isSelected ? Color(uiColor: UIColor.Theme.primaryTeal) : .white)
            Image(isSelected ? tabSelectedImageName : tabImageName)
                .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(viewModel: HomeViewModel())
    }
}
