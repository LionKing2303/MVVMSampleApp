//
//  MainViewController.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import UIKit
import Combine

enum Section {
    case main
}

class MainViewController: UIViewController {

    // MARK: -- Outlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -- Variables
    let viewModel: MainViewModel = .init(service: MainService())
    var dataSource: UITableViewDiffableDataSource<Section,MainTableViewCellViewModel>!
    var cancellables = Set<AnyCancellable>()
    
    // MARK: -- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchField()
        configureTable()
        bindTable()
        loadData()
    }
    
    // MARK: -- Private methods
    private func configureSearchField() {
        searchField.delegate = self
    }
    
    private func configureTable() {
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        dataSource = .init(tableView: tableView, cellProvider: {
            (tableView, indexPath, viewModel) -> UITableViewCell? in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier) as? MainTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            return cell
        })
    }
    
    private func bindTable() {
        viewModel.$filtered
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applySnapshot(with: items)
            }
            .store(in: &cancellables)
    }
    
    private func loadData() {
        viewModel.fetchRepositories()
    }
    
    private func applySnapshot(with items: [MainTableViewCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section,MainTableViewCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            // Ask the view model to filter the items
            viewModel.searchText = updatedText
        }
        return true
    }
}
