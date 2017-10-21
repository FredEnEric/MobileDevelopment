//
//  SearchTableViewController.swift
//  OmnomTracker
//
//  Created by Student on 17/10/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var meals = ["Spaghetti", "yoghurt", "banaan", "chicken", "Frietjes"]
    var filteredMeals = [String]()
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }

    func updateSearchResults(for searchController: UISearchController) {
        // filter
        self.filteredMeals = self.meals.filter{ (meal:String) -> Bool in
            return meal.lowercased().contains(self.searchController.searchBar.text!.lowercased())
        }
        // update view
        self.resultsController.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.meals.count
        }
        return self.filteredMeals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if tableView == self.tableView {
            cell.textLabel?.text =  self.meals[indexPath.row]
        } else {
            cell.textLabel?.text =  self.filteredMeals[indexPath.row]
        }
        return cell
    }
 
}
