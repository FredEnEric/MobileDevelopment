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

class LogMealViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
    let mealTimes = ["Breakfast", "Lunch", "Dinner", "Snack", "Drink"]
    let mealTimePicker = UIPickerView()
    let foodRepo = FoodRepository()
    let foodModel = FoodModel()
    
    var mealName = "Omnomnom"
    var mealId = "not set" 
    
    let baseURL = "https://trackapi.nutritionix.com/v2/search/instant?branded=false&detailed=true&query="
    let headers: HTTPHeaders = [
        "x-app-id": "77087a10",
        "x-app-key": "e36cf96bcf70f79f039149a7711d1890"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getDataFromApi()
        createMealTimePicker()
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
    
    
    //MARK: - Fetch data from api
    
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
    
    
    //MARK: - UpdateUI
    
    private func updateUI(data: NSDictionary) {
        if let servingSize = data["serving_weight_grams"] as? Double {
            portionSizeLabel.text = String(format:"%.2f g", servingSize)
        }
        
        
        if let nutrients = data["full_nutrients"] as? NSArray {
            for nutrientObject in nutrients {
                if let nutrient = nutrientObject as? NSDictionary {
                    let id = nutrient["attr_id"] as! Int32
                    let value = nutrient["value"] as! Float
                    let valueString = String(format:"%.2f", value)
                    switch id {
                    case carbsId:
                        foodModel.carbs = value
                        carbsLabel.text = "\(valueString) g"
                    case proteinId:
                        foodModel.protein = value
                        proteinsLabel.text = "\(valueString) g"
                    case fatId:
                        foodModel.fat = value
                        fatsLabel.text = "\(valueString) g"
                    case caloriesId:
                        foodModel.calories = Int32(value)
                        caloriesLabel.text = "\(valueString) kCal"
                    default:
                        continue
                    }
                }
            }
        }
    }
    
    
    //MARK: - Picker
    
    func createMealTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressing))
        toolbar.setItems([done], animated: false)
        mealTimeField.inputAccessoryView = toolbar
        
        mealTimePicker.delegate = self
        mealTimePicker.dataSource = self
        
        mealTimeField.inputView = mealTimePicker
    }
    
    
    @objc func donePressing(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mealTimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mealTimeField.text = mealTimes[row]
        foodModel.lunch = Int32(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mealTimes[row]
    }
    
    
    //MARK: - Store data
    
    func putMealInDatabase() {
   
        foodModel.name = mealName.capitalized
        foodModel.date = Date() as NSDate
        foodModel.portions = Int16(amountOfPortionsField.text!)!
        //save food in repo
        foodRepo.add(model: foodModel)
    }
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "logMealFinishedSegue" {
            if ((mealTimeField.text?.isEmpty)! || (amountOfPortionsField.text?.isEmpty)!) {
                let alert = UIAlertView()
                alert.title = "Invalid form"
                alert.message = "Please enter all fields"
                alert.addButton(withTitle: "Ok")
                alert.show()
                return false
            }
            else if (Int(amountOfPortionsField.text!) == nil) {
                let alert = UIAlertView()
                alert.title = "Invalid form"
                alert.message = "Please enter a correct portion size"
                alert.addButton(withTitle: "Ok")
                alert.show()
                return false
            }
            else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
    
}


    //MARK: Textfield extension
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
