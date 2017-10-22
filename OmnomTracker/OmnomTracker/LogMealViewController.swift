//
//  LogMealViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 10/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit
import CoreData

class LogMealViewController: UIViewController {

    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var portionSizeField: UITextField!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbProcentLabel: UILabel!
    @IBOutlet weak var carbGramsLabel: UILabel!
    @IBOutlet weak var proteinProcentLabel: UILabel!
    @IBOutlet weak var proteinGramsLabel: UILabel!
    @IBOutlet weak var fatProcentLabel: UILabel!
    @IBOutlet weak var fatGramsLabel: UILabel!

    var mealName = "Omnomnom"
    
    var lunch = Int32()
    var foodRepo = FoodRepository()
    var foodModel = FoodModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mealNameLabel.text = mealName
    }
    
    //als we op save klikken
    override func viewDidDisappear(_ animated: Bool) {
        putMealInDatabase()
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func putMealInDatabase() {
        //let food: Food = NSEntityDescription.insertNewObject(forEntityName: "Food", into: DatabaseController.persistentContainer.viewContext) as! Food
        
        foodModel.name = mealNameLabel.text!
        /*
        food.calories = Int32(caloriesLabel.text!)!
        food.carbs = Float(carbGramsLabel.text!)!
        food.protein = Float(proteinGramsLabel.text!)!
        food.fat = Float(fatGramsLabel.text!)!
        */
        
        //dit moet achteraf als frederic api werkend heeft gekregen vervangen worden door hierboven.
        foodModel.calories = 10
        foodModel.carbs = 10
        foodModel.protein = 10
        foodModel.fat = 10
        foodModel.lunch = lunch
        
        //save food in repo
        foodRepo.add(model: foodModel)
    }
    


}
