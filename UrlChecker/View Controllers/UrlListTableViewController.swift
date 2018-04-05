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
        
        navigationItem.searchController = searchController
        
        // Register cell nib
        tableView.register(UINib(nibName: "UrlTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UrlCellId")

        // Fill fake data
        dataSource.append(UrlModel(url: "https://www.google.com"))
        dataSource.append(UrlModel(url: "https://github.com"))
        dataSource.append(UrlModel(url: "https://www.youtube.com"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
