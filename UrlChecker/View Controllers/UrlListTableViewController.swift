//
//  UrlListTableViewController.swift
//  UrlChecker
//
//  Created by Sygnoos9 on 4/5/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UrlListTableViewController: UITableViewController {

    @IBOutlet var tableHeaderView: UIView!
    
    enum SortType: Int {
        case name, status, duration
    }

    let searchController = UISearchController(searchResultsController: nil)
    var isSearching = false

    var originalDataSource: [UrlModel] = []
    var searchedDataSource: [UrlModel] = []

    var dataSource: [UrlModel] {
        if isSearching {
            return searchedDataSource
        } else {
            return originalDataSource
        }
    }

    var sortType = SortType.name
    var descending = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "URL Checker"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure SearchBar
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.scopeButtonTitles = ["by name", "by status", "by response"]
        searchController.searchBar.delegate = self

        // Register cell nib
        tableView.register(UINib(nibName: "UrlTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UrlCellId")

        // Fill fake data
        for _ in 1...2 {
        originalDataSource.append(UrlModel(url: "https://www.google.com"))
        originalDataSource.append(UrlModel(url: "https://github.com"))
        originalDataSource.append(UrlModel(url: "youtube.com"))
        }
        sort()
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        dataSource.forEach { (model) in
            model.status = .unknown
        }
        tableView.reloadData()
    }

    @IBAction func addAction(_ sender: Any) {
        let alert = UIAlertController(title: "Enter new URL address", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "url"
        }

        let okAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let url = alert.textFields?.first?.text {
                let newModel = UrlModel(url: url)
                self.originalDataSource.append(newModel)
                self.sort()
            }
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sortTypeDidChange(_ sender: UISegmentedControl) {
        let selectedScope = sender.selectedSegmentIndex
        sortType = SortType(rawValue: selectedScope)!
        
        sort()
    }
    
    @IBAction func ascendingDidChange(_ sender: UISegmentedControl) {
        let selectedScope = sender.selectedSegmentIndex
        switch selectedScope {
        case 0: descending = false
        case 1: descending = true
        default: break
        }

        sort()
    }

    func sort() {
        switch sortType {
        case .name: sort(byName: descending)
        case .status: sort(byStatus: descending)
        case .duration: sort(byDuration: descending)
        }
    }

    func sort(byName descending: Bool) {
        originalDataSource.sort { (lhs, rhs) -> Bool in
            if descending {
                return lhs.urlAddress > rhs.urlAddress
            } else {
                return lhs.urlAddress < rhs.urlAddress
            }
        }
        tableView.reloadData()
    }
    
    func sort(byStatus descending: Bool) {
        originalDataSource.sort { (lhs, rhs) -> Bool in
            if descending {
                return UInt8(lhs.status.rawValue) > UInt8(rhs.status.rawValue)
            } else {
                return UInt8(lhs.status.rawValue) < UInt8(rhs.status.rawValue)
            }
        }
        tableView.reloadData()
    }
    
    func sort(byDuration descending: Bool) {
        originalDataSource.sort { (lhs, rhs) -> Bool in
            if descending {
                return lhs.requestDuration > rhs.requestDuration
            } else {
                return lhs.requestDuration < rhs.requestDuration
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UrlCellId", for: indexPath) as! UrlTableViewCell

        // Configure the cell...
        let model = dataSource[indexPath.row]

        cell.textLabel?.text = model.urlAddress
        cell.detailTextLabel?.text = "in \(String(format:"%.2f", model.requestDuration)) sec"

        switch model.status {
        case .unknown:
            cell.backgroundColor = UIColor.white
            cell.indicator.startAnimating()
            model.checkStatus { (valid) in
                DispatchQueue.main.async {
                    cell.indicator.stopAnimating()
                    if let indexPath = tableView.indexPath(for: cell) {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        case .valid:
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        case .invalid:
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        case .checking:
            cell.indicator.startAnimating()
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = dataSource[indexPath.row]
        
        guard let url = URL(string: model.urlAddress) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            print("Can't open URL")
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            originalDataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func toogleTableHeaderView() {
        if tableView.tableHeaderView == nil {
            tableView.tableHeaderView = tableHeaderView
        } else {
            tableView.tableHeaderView = nil
        }
    }
}

extension UrlListTableViewController: UISearchBarDelegate {

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        toogleTableHeaderView()
        searchedDataSource = originalDataSource
        tableView.reloadData()
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchedDataSource = originalDataSource
            tableView.reloadData()
            return
        }

        searchedDataSource = originalDataSource.filter({ (model) -> Bool in
            model.urlAddress.localizedCaseInsensitiveContains(searchText)
        })
        tableView.reloadData()
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        toogleTableHeaderView()
        tableView.reloadData()
    }
}
