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
        
    private var viewModel: MainTableViewCellViewModel?
    
    func configure(with viewModel: MainTableViewCellViewModel) {
        self.viewModel = viewModel
        
        repositoryName.text = self.viewModel?.repositoryName
        defaultBranchName.text = self.viewModel?.defaultBranchName
        language.text = self.viewModel?.language
        
        self.viewModel?.didFetchAvatar = { [weak self] image in
            DispatchQueue.main.async {
                self?.avatar.layer.cornerRadius = 10.0
                self?.avatar.image = image
            }
        }
        self.viewModel?.fetchAvatar()
    }
}
