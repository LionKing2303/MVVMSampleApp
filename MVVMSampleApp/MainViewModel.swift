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
    private var repos: [MainTableViewCellModel] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: -- Public variables
    @Published var filtered: [MainTableViewCellModel] = []
    @Published var searchText: String = ""

    init(service: Service) {
        self.service = service
        
        $searchText.sink { [weak self] text in
            self?.filter(with: text)
        }
        .store(in: &cancellables)
    }
    
    func fetchRepositories() {
        service.fetchData()
            .receive(on: DispatchQueue.main)
            .map { item in
                item.map(\.toCellModel)
            }
            .replaceError(with: [])
            .sink { [weak self] repos in
                guard let self = self else { return }
                self.repos = repos
                self.filtered = self.repos
            }
            .store(in: &cancellables)
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
