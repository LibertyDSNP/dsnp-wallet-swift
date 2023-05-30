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
            AMPHomeView(viewModel: AMPHomeViewModel(), showingAlert: showingAlert)
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

struct AMPHomeView: View {
    
    @ObservedObject var viewModel: AMPHomeViewModel
    
    @State var showingAlert: Bool = false
    
    var body: some View {
        ZStack {
            if showingAlert {
                CongratsModal(viewModel: CongratsViewModel())
            }
            VStack {
                profileImage
                handleHeadline
                addressSubheadline
                metaDatafields
            }
            .background(Color(uiColor: UIColor.Theme.bgTeal))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color(uiColor: UIColor.Theme.bgTeal))
    }
    
    private var profileImage: some View {
        ZStack {
            Image("profile_placeholder")
            editButton
        }
    }
    
    private var editButton: some View {
        Button {
            viewModel.toggleEditMode()
        } label: {
            Image("editButton")
        }
        .frame(maxWidth: 16, maxHeight: 16, alignment: .center)
        .background(Color(uiColor: UIColor.Theme.primaryTeal))
        .cornerRadius(8)
    }
    
    private var handleHeadline: some View {
        Text("handle goes here")
    }
    
    private var addressSubheadline: some View {
        Text("wallet address")
    }
    
    private var metaDatafields: some View {
        VStack {
            firstNameField
            lastNameField
            emailField
        }
    }
    
    private var firstNameField: some View {
        TextField("first name", text: $viewModel.firstNameText)
    }
    
    private var lastNameField: some View {
        TextField("last name", text: $viewModel.lastNameText)
    }
    
    private var emailField: some View {
        TextField("email", text: $viewModel.emailText)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(viewModel: HomeViewModel())
    }
}
