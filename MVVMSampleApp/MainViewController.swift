//
//  MainViewController.swift
//  MVVMSampleApp
//
//  Created by Arie Peretz on 17/08/2021.
//

import UIKit

protocol MainViewControllerDelegate {
    func updateUI()
}

class MainViewController: UIViewController {

    // MARK: -- Outlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -- Variables
    lazy var viewModel: MainViewModel = .init(service: MainService(), viewDelegate: self)

    // MARK: -- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        configureSearchField()
        loadData()
    }
    
    // MARK: -- Private methods
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
        viewModel.fetchRepositories()
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
            viewModel.filter(with: updatedText)
        }
        return true
    }
}

extension MainViewController: MainViewControllerDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        }
    }
}
