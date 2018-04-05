//
//  UrlListTableViewController.swift
//  UrlChecker
//
//  Created by Sygnoos9 on 4/5/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit

class UrlListTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    var dataSource: [UrlModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "URL Checker"
        
        // Configure SearchBar
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["by name", "by status", "by response"]

        // Register cell nib
        tableView.register(UINib(nibName: "UrlTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UrlCellId")

        // Fill fake data
        for _ in 1...5 {
        dataSource.append(UrlModel(url: "https://www.google.com"))
        dataSource.append(UrlModel(url: "https://github.com"))
        dataSource.append(UrlModel(url: "youtube.com"))
        }
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
                self.dataSource.append(newModel)
                self.tableView.reloadData()
            }
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
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


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
