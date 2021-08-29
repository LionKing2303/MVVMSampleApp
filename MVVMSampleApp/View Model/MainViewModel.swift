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
    private var repos: [MainViewCell.ViewModel] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: -- Public variables
    @Published var filtered: [MainViewCell.ViewModel] = []
    @Published var searchText: String = ""

    init(service: Service) {
        self.service = service
        
        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.filter(with: text)
            }
            .store(in: &cancellables)
    }
    
    func fetchRepositories() {
        service.fetchData()
            .receive(on: DispatchQueue.main)
            .map { item in
                item.map { $0.toCellModel }
            }
            .replaceError(with: [])
            .sink { [weak self] repos in
                guard let self = self else { return }
                self.repos = repos.map(MainViewCell.ViewModel.init)
                self.filtered = self.repos
            }
            .store(in: &cancellables)
    }
    
    func filter(with text: String) {
        // Filter items that their repository name contains a text (case-insensitive)
        filtered = repos
            .filter { viewModel in
                if text.count == 0 { return true }
                return viewModel.item.repositoryName.lowercased().contains(text.lowercased())
            }
    }
}
