//
//  MainView.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 20/08/2021.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel = .init(service: MainService())
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Github Repos")
                        .font(.system(size: 32, weight: .bold, design: .default))
                    Spacer()
                }
                TextField("Repository name", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.system(size: 22))
            }
            .padding()
            List(viewModel.filtered, id: \.repositoryName) { item in
                MainViewCell(viewModel: MainViewCell.ViewModel(item: item))
            }
            .animation(.spring())
        }
        .onAppear {
            viewModel.fetchRepositories()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 12 Pro Max")
    }
}
