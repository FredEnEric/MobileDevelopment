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
    @IBOutlet weak var caloriesProcentLabel: UILabel!
    @IBOutlet weak var carbGramsLabel: UILabel!
    @IBOutlet weak var proteinGramsLabel: UILabel!
    
    @IBOutlet weak var fatGramsLabel: UILabel!

    var mealName = "Omnomnom"
    var mealId = "not set"
    
    var lunch = Int32()
    var foodRepo = FoodRepository()
    var foodModel = FoodModel()
    var proteinId : Int32 = 203
    var caloriesId : Int32 = 208
    var fatId : Int32 = 204
    var carbsId : Int32 = 205
    
    var baseURL = "https://trackapi.nutritionix.com/v2/search/instant?branded=false&detailed=true&query="
    var xAppId = "77087a10"
    var xAppKey = "e36cf96bcf70f79f039149a7711d1890"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mealNameLabel.text = mealName
        
        let searchText = self.mealName.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "\(self.baseURL)\(searchText)")
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
                        for meal in meals {
                            if let mealDictionary = meal as? NSDictionary {
                                let mealName : String = mealDictionary["food_name"] as! String
                                let mealId = mealDictionary["tag_id"] as! String
                                if mealName == self.mealName && mealId == self.mealId {
                                    if let nutrients = mealDictionary["full_nutrients"] as? NSArray {
                                        for nutrientObject in nutrients {
                                            if let nutrient = nutrientObject as? NSDictionary {
                                                let id = nutrient["attr_id"] as! Int32
                                                switch id {
                                                case self.carbsId:
                                                    self.carbGramsLabel.text = "\(nutrient["value"] as! NSNumber) g"
                                                case self.proteinId:
                                                    self.proteinGramsLabel.text = "\(nutrient["value"] as! NSNumber) g"
                                                case self.fatId:
                                                    self.fatGramsLabel.text = "\(nutrient["value"] as! NSNumber) g"
                                                case self.caloriesId:
                                                    self.caloriesLabel.text = "\(nutrient["value"] as! NSNumber) kCal"
                                                default:
                                                    continue
                                                }
                                            }
                                        }
                                    }
                                    break
                                }
                            }
                        }
                        
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
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
        //foodModel.lunch = lunch
        
        //save food in repo
        foodRepo.add(model: foodModel)
    }
    


    
}
