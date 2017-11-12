//
//  HistoryTableViewController.swift
//  OmnomTracker
//
//  Created by Student on 06/11/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var keys = [Int]()
    var cellLabels = [Int: String]()
    var store = [Int: [Food]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        //self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        clearData()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func clearData() {
        keys = [Int]()
        cellLabels = [Int: String]()
        store = [Int: [Food]]()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell()
        // Configure the cell...
        cell.textLabel?.text = cellLabels[keys[indexPath.row]]
        
        return cell
    }
    
    func fetchData() {
        let repository = FoodRepository()
        let foods = repository.getAll()
        let prettyDateFormat = DateFormatter()
        prettyDateFormat.dateFormat = "EEEE, d MMM yyyy"
        let keyDateFormat = DateFormatter()
        keyDateFormat.dateFormat = "yyyyMMdd"
        
        for food in foods {
            guard let date = food.date as Date? else {
                // date is nil, ignore this entry:
                continue
            }
            let key = Int(keyDateFormat.string(from: date))!
            if (store[key] == nil) {
                store[key] = [Food]()
                cellLabels[key] = prettyDateFormat.string(from: date)
            }
            store[key]?.append(food)
        }
        keys = cellLabels.keys.sorted(by: >)
    }

    
    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key =  keys[indexPath.row]
        performSegue(withIdentifier: "viewDaySegue", sender: key)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let dayViewController = segue.destination as! DayViewController
        dayViewController.date = cellLabels[sender as! Int]!
        dayViewController.foods = store[sender as! Int]!
    }
    
}
