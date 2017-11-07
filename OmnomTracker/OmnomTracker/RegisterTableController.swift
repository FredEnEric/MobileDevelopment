//
//  RegisterTableController.swift
//  OmnomTracker
//
//  Created by Student on 14/10/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit
import CoreData

class RegisterTableController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //passing data vars
    var genderString = String()
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var weightGoaldField: UITextField!
    @IBOutlet weak var calorieGoaldField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    //pickers
    let picker = UIDatePicker()
    var genderPicker = UIPickerView()
    var heightPicker = UIPickerView()
    var weightPicker = UIPickerView()
    var calorieGoalPicker = UIPickerView()
    var weightgoalPicker = UIPickerView()
    
    //var
    var height = Float()
    var weight = Float()
    var calorieGoal = Int16()
    var dateBirth = NSDate()
    var gender = String()
    var userId = NSInteger()
    var weightGoal = Float()
    
    //data
    var genderData = ["Female", "Male", "Other"]
    var heightData = [Int]()
    var weightData = [Float]()
    var weightGoaldData = [Float]()
    var calorieGoaldData = [Int]()
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        //genderData wordt hierboven al genereert
        heightData = generateHeightData()
        weightData = generateWeightData()
        weightGoaldData = weightData
        calorieGoaldData = generateCalorieData()
        
        createDatePicker()
        craetePicker(field: genderField, picker: genderPicker)
        craetePicker(field: heightField, picker: heightPicker)
        craetePicker(field: weightField, picker: weightPicker)
        craetePicker(field: weightGoaldField, picker: weightgoalPicker)
        craetePicker(field: calorieGoaldField, picker: calorieGoalPicker)
        
        genderField.text = genderString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //als we op save klikken
    override func viewDidDisappear(_ animated: Bool) {
        putUserInDatabase()
        self.navigationController?.navigationBar.isHidden = false
        super.viewDidDisappear(animated)
    }
    
    
    func putUserInDatabase() {
        let user: User = NSEntityDescription.insertNewObject(forEntityName: "User", into: DatabaseController.persistentContainer.viewContext) as! User
        
        user.height = height
        user.weight = weight
        user.calorieGoal = calorieGoal
        //user.dateBirth = nil
        user.gender = gender as String
        user.userId = 1
        user.weightGoal = weightGoal
        
        //save user in DB
        DatabaseController.saveContext()
    }
    
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button for toolbar, action refers to method donePressed().
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        dateField.inputAccessoryView = toolbar
        dateField.inputView = picker
        
        //for picker for date (day, month, year) also for putting the formatted date in the database
        picker.datePickerMode = .date
    }
    
    func craetePicker(field: UITextField, picker: UIPickerView) {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressing))
        toolbar.setItems([done], animated: false)
        field.inputAccessoryView = toolbar
        
        picker.delegate = self
        picker.dataSource = self
        
        field.inputView = picker
    }
    
    @objc func donePressed(){
        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        //put the picked date in the textfield (dateField)
        dateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    @objc func donePressing(){
        self.view.endEditing(true)
    }
    
    func generateHeightData() -> Array<Int> {
        //declare array
        var heightArray = [Int]()
        
        //add each item in array
        for height in 50...220 {
            heightArray.append(height)
        }
        return heightArray
    }
    
    func generateWeightData() -> Array<Float> {
        //declare array
        var weightArray = [Float]()
        
        //add each item in array
        for weight in stride(from: 25.0, to: 200.0, by: 0.1) {
            weightArray.append(Float(weight))
        }

        return weightArray
    }
    
    func generateCalorieData() -> Array<Int> {
        //declare array
        var calorieArray = [Int]()
        
        //add each item in array, increment by 10
        for cal in stride(from: 300, to: 5000, by: 10) {
            calorieArray.append(cal)
        }
        return calorieArray
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == genderPicker){
            return genderData.count
        } else if(pickerView == heightPicker) {
            return heightData.count
        } else if(pickerView == weightPicker) {
            return weightData.count
        } else if(pickerView == calorieGoalPicker) {
            return calorieGoaldData.count
        } else if(pickerView == weightgoalPicker) {
            return weightGoaldData.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == genderPicker){
            genderField.text = genderData[row]
            gender = (genderData[row]) as String
        } else if(pickerView == heightPicker) {
            heightField.text = String(heightData[row]) + " cm"
            height = Float(heightData[row])
        } else if(pickerView == weightPicker) {
            weightField.text = String(weightData[row]) + " kg"
            weight = Float(weightData[row])
        } else if(pickerView == calorieGoalPicker) {
            calorieGoaldField.text = String(calorieGoaldData[row]) + " kcal"
            calorieGoal = Int16(calorieGoaldData[row])
        } else if(pickerView == weightgoalPicker) {
            weightGoaldField.text = String(weightGoaldData[row]) + " kg"
            weightGoal = Float(weightGoaldData[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == genderPicker){
            return genderData[row]
        } else if(pickerView == heightPicker) {
            return String(heightData[row]) + " cm"
        } else if(pickerView == weightPicker) {
            return String(weightData[row]) + " kg"
        } else if(pickerView == calorieGoalPicker) {
            return String(calorieGoaldData[row]) + " kcal"
        } else if(pickerView == weightgoalPicker) {
            return String(weightGoaldData[row]) + " kg"
        } else {
            return ""
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "registrationFinishedSegue" {
            let isValid = self.isValid()
            if (!isValid) {
                let alert = UIAlertView()
                alert.title = "Invalid form"
                alert.message = "Please enter all fields"
                alert.addButton(withTitle: "Ok")
                alert.show()
            }
            return isValid
        }
        
        // by default, transition
        return true
    }
    
    func isValid() -> Bool {
        
        if(height != 0 && weight != 0 && calorieGoal != 0 && !gender.isEmpty && weightGoal != 0) {
            return true
        }
        return false
        
    }
}
