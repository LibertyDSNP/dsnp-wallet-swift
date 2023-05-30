//
//  HomeView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/30/23.
//

import SwiftUI

struct HomeTabView: View {
    
    let viewModel: HomeViewModel
    
    @State private var showingSheet = false

    
    var body: some View {
        TabView {
            AMPHomeView()
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
        .sheet(isPresented: $showingSheet) {
            CongratsModal(viewModel: CongratsViewModel())
        }
        .accentColor(Color(uiColor: UIColor.Theme.primaryTeal))
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct ProfileView: View {
    
    var body: some View {
        VStack {
            
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct SettingsView: View {
    
    var body: some View {
        VStack {
            
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct AMPHomeView: View {
    
    var body: some View {
        VStack {
            
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(viewModel: HomeViewModel())
    }
}
