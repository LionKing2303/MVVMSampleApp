//
//  MainViewModel.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import Foundation

final class MainViewModel {
    // MARK: -- Private variables
    private let service: Service
    private var repos: [MainTableViewCellModel] = []
    private var viewDelegate: MainViewControllerDelegate?
    
    // MARK: -- Public variables
    var filtered: [MainTableViewCellModel] = [] {
        didSet {
            viewDelegate?.updateUI()
        }
    }
    
    init(service: Service, viewDelegate: MainViewControllerDelegate) {
        self.service = service
        self.viewDelegate = viewDelegate
    }
    
    func fetchRepositories() {
        service.fetchData { [weak self] (repos) in
            guard let self = self else { return }
            
            // Formatting the data model into representable model
            self.repos = repos
                .map(\.toCellModel)
            self.filtered = self.repos
        }
    }
    
    func filter(with text: String) {
        // Filter items that their repository name contains a text (case-insensitive)
        filtered = repos
            .filter { model in
                if text.count == 0 { return true }
                return model.repositoryName.lowercased().contains(text.lowercased())
            }
    }
}
