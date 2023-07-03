//
//  ImportSeedView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/16/23.
//

import SwiftUI

struct ImportSeedView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ImportSeedViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                AmplicaHeadline(withBackButton: true) {
                    dismiss()
                }
                headline
                seedphraseField
                description
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                buttonStack
                TermsDisclaimerView(color: .white)
                    .padding(.bottom, 40)
                Spacer()
            }
            .background(Color(uiColor: UIColor.Theme.bgTeal))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
    
    var headline: some View {
        Text("Import Account")
            .font(Font(UIFont.Theme.bold(ofSize: 24)))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var seedphraseField: some View {
        ZStack {
            if #available(iOS 16.0, *) {
                TextEditor(text: $viewModel.seedPhraseText)
                    .padding()
                    .font(Font(UIFont.Theme.regular(ofSize: 12)))
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
                    .frame(height: 220)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(15)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color(uiColor: UIColor.Theme.seedImportBgColor)))
                    .overlay(
                        viewModel.state == .error ?
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(uiColor: UIColor.Theme.importErrorRed))
                        :
                            RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(uiColor: UIColor.Theme.seedImportBorderColor))
                    )
                    .padding(.horizontal, 24)
                    .disabled(viewModel.state == .error)
                if viewModel.state == .error {
                    errorDescription
                }
            } else {
                TextEditor(text: $viewModel.seedPhraseText)
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
                    .frame(height: 220)
                    .border(Color(uiColor: UIColor.Theme.seedImportBorderColor), width: 5)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color(uiColor: UIColor.Theme.seedImportBgColor)))
                    .overlay(
                        viewModel.state == .error ?
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(uiColor: UIColor.Theme.importErrorRed))
                        :
                            RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(uiColor: UIColor.Theme.seedImportBorderColor))
                    )
                    .padding(.horizontal, 20)
            }
        }
    }
    
    var description: some View {
        Text("Enter your 12 word recovery phase to connect your account")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var errorDescription: some View {
        Text("When you encounter an “Invalid menemonic phrase” Error, you need to check the following:\n\nThe words are separated by a single space.\nThe words should be in the correct order.\nThe words are spelled correctly.")
            .font(Font(UIFont.Theme.regular(ofSize: 12)))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(12)
            .padding(.horizontal, 20)
    }
    
    var buttonStack: some View {
        VStack {
            if viewModel.state == .error {
                errorStateButtons
                    .padding(.bottom, 14)
            } else {
                NavigationLink(destination: HomeTabView(viewModel: HomeViewModel(user: viewModel.user)), tag: 1, selection: $viewModel.shouldPush) {
                    Text("Connect")
                        .font(Font(UIFont.Theme.bold(ofSize: 15)))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 12)
                        .foregroundColor(!viewModel.textfieldDisabled ? .white : Color(uiColor: UIColor.Theme.bgTeal))
                }
                .frame(maxWidth: .infinity)
                .background(viewModel.textfieldDisabled ? Color(uiColor: UIColor.Theme.bgGray) : Color(uiColor: UIColor.Theme.buttonTeal))
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
                .disabled(viewModel.shouldPush != 1)
                .onTapGesture {
                    if !viewModel.textfieldDisabled {
                        viewModel.submitAction.send()
                    }
                }
            }
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .foregroundColor(.white)
                    .font(Font(UIFont.Theme.regular(ofSize: 14)))
                    .underline()
            }
        }
    }
    
    var errorStateButtons: some View {
        HStack {
            Button {
                viewModel.state = .editing
            } label: {
                Text("Try Again")
                    .font(Font(UIFont.Theme.bold(ofSize: 12)))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .foregroundColor(.white)
                    .frame(width: 160, height: 46)
            }
            .background(Color(uiColor: UIColor.Theme.buttonTeal))
            .cornerRadius(30)
            Spacer()
            NavigationLink(destination: ClaimHandleView(viewModel: ClaimHandleViewModel())) {
                Text("Create Identity")
                    .font(Font(UIFont.Theme.bold(ofSize: 12)))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .foregroundColor(.white)
                    .frame(width: 160, height: 46)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(uiColor: UIColor.Theme.primaryTeal))
                    )
            }
            .background(.clear)
            .cornerRadius(30)
        }
        .padding(.horizontal, 24)
    }
}


struct ImportSeedView_Previews: PreviewProvider {
    static var previews: some View {
        ImportSeedView(viewModel: ImportSeedViewModel())
    }
}
