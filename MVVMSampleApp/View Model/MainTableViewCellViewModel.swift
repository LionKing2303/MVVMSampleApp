//
//  MainTableViewCellViewModel.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 23/09/2021.
//

import Foundation
import UIKit

final class MainTableViewCellViewModel {
    // MARK: -- Private variables
    private let model: MainTableViewCellModel
    private let defaultAvatarImage = UIImage(named: "person.fill")
    private var avatar: UIImage? {
        didSet {
            didFetchAvatar?(avatar)
        }
    }

    // MARK: -- Public variables
    private(set) var repositoryName: String?
    private(set) var defaultBranchName: String?
    private(set) var language: String?
    var didFetchAvatar: ((UIImage?)->Void)? {
        didSet {
            didFetchAvatar?(avatar)
        }
    }
    
    init(model: MainTableViewCellModel) {
        self.model = model
        
        avatar = defaultAvatarImage
        repositoryName = self.model.repositoryName
        defaultBranchName = "Default branch: \(self.model.defaultBranchName)"
        language = "Language: \(self.model.language)"        
    }
    
    func repositoryNameContains(_ text: String) -> Bool {
        guard text.count > 0 else { return true }
        return model.repositoryName.lowercased().contains(text.lowercased())
    }
    
    func fetchAvatar() {
        guard avatar == nil || avatar == defaultAvatarImage else {
            didFetchAvatar?(avatar)
            return
        }
        guard let url = URL(string: model.avatarURL) else {
            avatar = defaultAvatarImage
            return
        }

        // Fetch image from server
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                self?.avatar = self?.defaultAvatarImage
                return
            }
            
            self?.avatar = UIImage(data: data)
        }
        task.resume()
    }
}
