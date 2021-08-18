//
//  MainTableViewCell.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var defaultBranchName: UILabel!
    @IBOutlet weak var language: UILabel!
        
    private let defaultAvatarImage = UIImage(systemName: "person.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    private var avatarImage: UIImage?
    
    func configure(with model: MainTableViewCellModel) {
        fetchAvatar(from: model.avatarURL)
        repositoryName.text = model.repositoryName
        defaultBranchName.text = "Default branch: \(model.defaultBranchName)"
        language.text = "Language: \(model.language)"
    }

    func fetchAvatar(from urlString: String) {
        // If already fetched use that
        if let avatarImage = avatarImage {
            self.avatar.image = avatarImage
            return
        }
        
        // Set default image - set this until we fetch from server
        self.avatar.image = defaultAvatarImage
        guard let url = URL(string: urlString) else { return }
        
        // Fetch image from server
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            
            let image = UIImage(data: data)
            
            // Store image
            self?.avatarImage = image
            
            // Update UI
            DispatchQueue.main.async {
                self?.avatar.layer.cornerRadius = 10.0
                self?.avatar.image = image
            }
        }
        task.resume()
    }
}
