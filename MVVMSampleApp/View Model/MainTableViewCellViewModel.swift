//
//  MainTableViewCellViewModel.swift
//  MainTableViewCellViewModel
//
//  Created by Arie Peretz on 21/09/2021.
//

import Combine
import UIKit

final class MainTableViewCellViewModel: ObservableObject {
    // MARK: -- Private variables
    private let model: MainTableViewCellModel
    private let defaultAvatarImage = UIImage(named: "person.fill")
    private var task: AnyCancellable?
    
    // MARK: -- Public variables
    @Published private(set) var repositoryName: String?
    @Published private(set) var defaultBranchName: String?
    @Published private(set) var language: String?
    @Published private(set) var avatar: UIImage?

    init(model: MainTableViewCellModel) {
        self.model = model
        
        avatar = defaultAvatarImage
        repositoryName = self.model.repositoryName
        defaultBranchName = "Default branch: \(self.model.defaultBranchName)"
        language = "Language: \(self.model.language)"
        
        fetchAvatar()
    }
    
    func repositoryNameContains(_ text: String) -> Bool {
        guard text.count > 0 else { return true }
        return model.repositoryName.lowercased().contains(text.lowercased())
    }
    
    private func fetchAvatar() {
        guard let url = URL(string: self.model.avatarURL) else { return }
        task = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .map(UIImage.init)
            .replaceError(with: defaultAvatarImage)
            .assign(to: \.avatar, on: self)
    }
}

extension MainTableViewCellViewModel: Hashable {
    static func == (lhs: MainTableViewCellViewModel, rhs: MainTableViewCellViewModel) -> Bool {
        lhs.model.repositoryName == rhs.model.repositoryName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model)
    }
}
