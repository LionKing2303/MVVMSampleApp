//
//  MainViewController.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: -- Outlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -- Variables
    let viewModel: MainViewModel = .init(service: MainService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        configureSearchField()
        loadData()
    }
    
    private func configureSearchField() {
        searchField.delegate = self
    }
    
    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func loadData() {
        viewModel.fetchRepositories { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier) as? MainTableViewCell else { return UITableViewCell() }
        let model = viewModel.filtered[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            viewModel.filter(with: updatedText) { [weak self] in
                self?.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
            }
        }
        return true
    }
}
