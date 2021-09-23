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
    private var repos: [MainTableViewCellViewModel] = [] {
        didSet {
            filtered = repos
        }
    }
    private var viewDelegate: MainViewControllerDelegate?
    
    // MARK: -- Public variables
    var searchText: String = "" {
        didSet {
            filtered = filter(with: searchText)
        }
    }
    private(set) var filtered: [MainTableViewCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.viewDelegate?.updateUI()
            }
        }
    }
    
    init(service: Service, viewDelegate: MainViewControllerDelegate) {
        self.service = service
        self.viewDelegate = viewDelegate
    }
    
    func fetchRepositories() {
        service.fetchData { [weak self] result in
            switch result {
            case .success(let repos):
                // Formatting the data model into representable model
                self?.repos = repos
                    .map { $0.toCellModel }
                    .map(MainTableViewCellViewModel.init)
            case .failure:
                self?.repos = []
            }
            
        }
    }
    
    private func filter(with text: String) -> [MainTableViewCellViewModel] {
        // Filter items that their repository name contains a text (case-insensitive)
        self.repos
            .filter { $0.repositoryNameContains(text) }
    }
}
