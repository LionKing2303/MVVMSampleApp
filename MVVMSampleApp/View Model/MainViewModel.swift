//
//  MainViewModel.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    // MARK: -- Private variables
    private let service: Service
    private var repos: [MainTableViewCellViewModel] = [] {
        didSet {
            filtered = repos
        }
    }
    private var cancellables = Set<AnyCancellable>()

    // MARK: -- Public variables
    @Published var searchText: String = ""
    @Published private(set) var filtered: [MainTableViewCellViewModel] = []
    
    init(service: Service) {
        self.service = service
        
        // When search text changes then
        // filter items that their repository
        // name contains a text (case-insensitive)
        $searchText
            .map(filter)
            .receive(on: DispatchQueue.main)
            .assign(to: \.filtered, on: self)
            .store(in: &cancellables)
    }
    
    func fetchRepositories() {
        service.fetchData()
            .map { item in
                item
                    .map(\.toCellModel)
                    .map(MainTableViewCellViewModel.init)
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.repos, on: self)
            .store(in: &cancellables)
    }
    
    private func filter(with text: String) -> [MainTableViewCellViewModel] {
        self.repos
            .filter { $0.repositoryNameContains(text) }
    }
}
