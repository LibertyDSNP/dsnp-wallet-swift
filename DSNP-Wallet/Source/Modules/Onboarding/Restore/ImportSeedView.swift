//
//  ImportSeedView.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 6/16/23.
//

import SwiftUI
import Combine

class ImportSeedViewModel: ObservableObject {
    @Published var seedPhraseText = ""

    let submitAction = PassthroughSubject<Void, Never>()

    private var cancellables = [AnyCancellable]()

    init() {
        setupObservables()
    }
    
    private func setupObservables() {
        $seedPhraseText
            .receive(on: RunLoop.main)
            .sink { [weak self] inputText in
                guard let self else { return }
                //check if the new string contains any invalid characters
                
            }
            .store(in: &cancellables)
        
        submitAction
            .sink { [weak self] in
                guard let self else { return }
                // TODO: Submit Seedphrase
            }
            .store(in: &cancellables)
    }
    
}

struct ImportSeedView: View {
    
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: ImportSeedViewModel

    var body: some View {
        VStack {
            AmplicaHeadline(withBackButton: true) {
                dismiss()
            }
            .padding(.top, 70)
            headline
            seedphraseField
            buttonStack
            Spacer()
        }
        .background(Color(uiColor: UIColor.Theme.bgTeal))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
    
    var headline: some View {
        Text("Import Account")
            .font(Font(UIFont.Theme.bold(ofSize: 24)))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var seedphraseField: some View {
        TextEditor(text: $viewModel.seedPhraseText)
            .frame(height: 220)
            .border(Color(uiColor: UIColor.Theme.seedImportBorderColor), width: 5)
            .disableAutocorrection(true)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black)
            )
            .cornerRadius(15)
            .padding(.horizontal, 20)
    }
    
    var buttonStack: some View {
        VStack {
            SecondaryButton(title: "Connect") {
                viewModel.submitAction.send()
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 10)
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
}

struct ImportSeedView_Previews: PreviewProvider {
    static var previews: some View {
        ImportSeedView(viewModel: ImportSeedViewModel())
    }
}
