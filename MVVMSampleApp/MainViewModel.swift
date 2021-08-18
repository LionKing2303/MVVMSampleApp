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
    
    // MARK: -- Public variables
    var filtered: [MainTableViewCellModel] = []
    
    init(service: Service) {
        self.service = service
    }
    
    func fetchRepositories(completionHandler: @escaping ()->Void) {
        service.fetchData { (repos) in
            
            // Business Logic
            self.repos = repos.map(\.toCellModel)
            self.filtered = self.repos
            
            // Notify View
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    func filter(with text: String, completionHandler: @escaping ()->Void) {
        // Filter items that their repository name contains a text (case-insensitive)
        filtered = repos.filter { model -> Bool in
            if text.count == 0 { return true }
            return model.repositoryName.lowercased().contains(text.lowercased())
        }
        
        // Notify View
        completionHandler()
    }
}
