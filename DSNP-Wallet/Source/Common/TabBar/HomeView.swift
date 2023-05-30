//
//  HomeView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import SwiftUI

struct HomeTabView: View {
    
    let viewModel: HomeViewModel
    
    @State var showingAlert = false
    
    var body: some View {
        TabView {
            AMPProfileView(viewModel: AMPHomeViewModel(), showingAlert: showingAlert)
                .tabItem {
                    VStack {
                        Text("Home")
                        Image("Home")
                    }
                }
            ProfileView()
                .tabItem {
                    VStack {
                        Text("Profile")
                        Image("Profile")
                    }
                }
            SettingsView()
                .tabItem {
                    VStack {
                        Text("Settings")
                        Image("Keys")
                    }
                }
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


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(viewModel: HomeViewModel())
    }
}
