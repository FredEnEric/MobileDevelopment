//
//  SearchTableViewController.swift
//  OmnomTracker
//
//  Created by Student on 17/10/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var meals = [String]()
    var ids = [String]()
    var selectedId = ""

    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    var baseURL = "https://trackapi.nutritionix.com/v2/search/instant?query="
    var xAppId = "77087a10"
    var xAppKey = "e36cf96bcf70f79f039149a7711d1890"
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
        let url = URL(string: "\(self.baseURL)\(self.searchController.searchBar.text!.lowercased())")
        var request = URLRequest(url: url!)
        request.setValue(self.xAppId, forHTTPHeaderField: "x-app-id")
        request.setValue(self.xAppKey, forHTTPHeaderField: "x-app-key")
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as AnyObject
                    if let meals = json["common"] as? NSArray{
                        // add
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
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
        // update view
        self.resultsController.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  self.meals[indexPath.row]
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
