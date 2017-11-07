//
//  LogMealViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 10/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class LogMealViewController: UIViewController {
    
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var portionSizeLabel: UILabel!
    @IBOutlet weak var amountOfPortionsField: UITextField!
    @IBOutlet weak var mealTimeField: UITextField!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    
    let proteinId : Int32 = 203
    let caloriesId : Int32 = 208
    let fatId : Int32 = 204
    let carbsId : Int32 = 205
    
    var mealName = "Omnomnom"
    var mealId = "not set"
    var lunch = Int32()
    var foodRepo = FoodRepository()
    var foodModel = FoodModel()
    
    let baseURL = "https://trackapi.nutritionix.com/v2/search/instant?branded=false&detailed=true&query="
    let headers: HTTPHeaders = [
        "x-app-id": "77087a10",
        "x-app-key": "e36cf96bcf70f79f039149a7711d1890"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getDataFromApi()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mealNameLabel.text = mealName.capitalized
        amountOfPortionsField.setBottomBorder()
        mealTimeField.setBottomBorder()
    }
    
    //als we op save klikken
    override func viewDidDisappear(_ animated: Bool) {
        putMealInDatabase()
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func getDataFromApi() {
        let url = "\(self.baseURL)\(self.mealName.replacingOccurrences(of: " ", with: "%20"))"
        Alamofire.request(url, headers: self.headers).responseJSON { response in
            if let data = response.result.value {
                if let meals = (data as AnyObject)["common"] as? NSArray{
                    for meal in meals {
                        if let mealDictionary = meal as? NSDictionary {
                            let mealName = mealDictionary["food_name"] as! String
                            let mealId = mealDictionary["tag_id"] as! String
                            if mealName == self.mealName && mealId == self.mealId {
                                self.updateUI(data: mealDictionary)
                                break
                            }
                        }
                    }
                    
                }
            }
        }
        
    }
    
    private func updateUI(data: NSDictionary) {
        if let servingSize = data["serving_weight_grams"] as? Double {
            self.portionSizeLabel.text = String(format:"%.2f g", servingSize)
        }
        
        
        if let nutrients = data["full_nutrients"] as? NSArray {
            for nutrientObject in nutrients {
                if let nutrient = nutrientObject as? NSDictionary {
                    let id = nutrient["attr_id"] as! Int32
                    let value = String(format:"%.2f", nutrient["value"] as! Double)
                    switch id {
                    case self.carbsId:
                        self.carbsLabel.text = "\(value) g"
                    case self.proteinId:
                        self.proteinsLabel.text = "\(value) g"
                    case self.fatId:
                        self.fatsLabel.text = "\(value) g"
                    case self.caloriesId:
                        self.caloriesLabel.text = "\(value) kCal"
                    default:
                        continue
                    }
                }
            }
            
        }
        
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

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
