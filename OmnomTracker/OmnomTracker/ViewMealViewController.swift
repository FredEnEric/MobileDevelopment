//
//  ViewMealViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 22/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class ViewMealViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var foodRepo = FoodRepository()
    
    //table
    var test = String()
    var foodList = [Food]()
    
    @IBOutlet weak var mealTable: UITableView!


    override func viewDidLoad() {
      

        super.viewDidLoad()
        print(test)

        mealTable.delegate = self
        mealTable.dataSource = self
        
        // Do any additional setup after loading the view.
        foodList = foodRepo.getAll()
        
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchTableViewController = segue.destination as! SearchTableViewController
        searchTableViewController.lunch = Int32(Lunch.breakfast.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mealTable.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = foodList[indexPath.row].name
        return cell
    }
}
