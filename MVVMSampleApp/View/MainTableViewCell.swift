//
//  MainTableViewCell.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import UIKit
import Combine

class MainTableViewCell: UITableViewCell {

    static let identifier = "MainTableViewCell"
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var defaultBranchName: UILabel!
    @IBOutlet weak var language: UILabel!
        
    private var viewModel: MainTableViewCellViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    func configure(with viewModel: MainTableViewCellViewModel) {
        self.viewModel = viewModel
        
        self.viewModel?.$repositoryName
            .assign(to: \.text, on: repositoryName)
            .store(in: &cancellables)
        
        self.viewModel?.$defaultBranchName
            .assign(to: \.text, on: defaultBranchName)
            .store(in: &cancellables)
        
        self.viewModel?.$language
            .assign(to: \.text, on: language)
            .store(in: &cancellables)
        
        avatar.layer.cornerRadius = 10.0
        self.viewModel?.$avatar
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: avatar)
            .store(in: &cancellables)
        
        self.viewModel?.fetchAvatar()
    }
}
