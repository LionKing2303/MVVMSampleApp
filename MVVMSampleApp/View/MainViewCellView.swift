//
//  MainViewCellView.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 21/08/2021.
//

import SwiftUI

struct MainViewCell: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            avatar
            VStack(alignment: .leading) {
                Text(viewModel.item.repositoryName)
                    .font(.system(size: 20))
                    .bold()
                Text("Default branch: \(viewModel.item.defaultBranchName)")
                    .font(.system(size: 20))
                Text("Language: \(viewModel.item.language)")
                    .font(.system(size: 20))
            }
        }
    }
    
    private var avatar: some View {
        if let uiImage = viewModel.image {
            return Image(uiImage: uiImage)
                .resizable()
                .frame(width: 92, height: 92)
                .foregroundColor(.clear)
        }
        return Image(systemName: "person.fill")
            .resizable()
            .frame(width: 92, height: 92)
            .foregroundColor(Color(UIColor.lightGray))
    }
}


struct MainViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MainViewCell(viewModel: .init(item: .init(avatarURL: "", repositoryName: "First repository", defaultBranchName: "Main", language: "Swift")))
    }
}
