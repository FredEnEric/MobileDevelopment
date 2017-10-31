//
//  SearchTableViewController.swift
//  OmnomTracker
//
//  Created by Student on 17/10/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit
import Alamofire

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var meals = [String]()
    var ids = [String]()
    var selectedId = ""

    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    var baseURL = "https://trackapi.nutritionix.com/v2/search/instant?branded=false&query="
    let headers: HTTPHeaders = [
        "x-app-id": "77087a10",
        "x-app-key": "e36cf96bcf70f79f039149a7711d1890"
    ]
    var lunch = Int32()
    
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
        // api call
        let searchText = self.searchController.searchBar.text!.lowercased().replacingOccurrences(of: " ", with: "%20")
        let url = "\(self.baseURL)\(searchText)"
        self.getDataFromApi(url: url )
        
        // update view
        self.resultsController.tableView.reloadData()
    }
    
    private func getDataFromApi(url: String) -> () {
        let searchText = self.searchController.searchBar.text!.lowercased().replacingOccurrences(of: " ", with: "%20")
        let url = "\(self.baseURL)\(searchText)"
        Alamofire.request(url, headers: self.headers).responseJSON { response in
            if let data = response.result.value {
                self.storeData(apiResponse: data as AnyObject)
            }
        }
        
    }
    
    private func storeData(apiResponse: AnyObject) {
        if let meals = apiResponse["common"] as? NSArray{
            self.meals = [String]()
            self.ids = [String]()
            for meal in meals {
                if let mealDictionary = meal as? NSDictionary {
                    let mealName = mealDictionary["food_name"] as! String
                    self.meals.append(mealName)
                    let mealId = mealDictionary["tag_id"] as! String
                    self.ids.append(mealId)
                }
            }
            
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  self.meals[indexPath.row].capitalized
        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal =  self.meals[indexPath.row]
        self.selectedId = self.ids[indexPath.row]
        performSegue(withIdentifier: "logMealSegue", sender: meal)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let logMealViewController = segue.destination as! LogMealViewController
        logMealViewController.lunch = Int32(Lunch.breakfast.rawValue)
        logMealViewController.mealName = sender as! String
        logMealViewController.mealId = self.selectedId
    }
    
}
