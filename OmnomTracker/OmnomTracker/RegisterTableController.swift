//
//  RegisterTableController.swift
//  OmnomTracker
//
//  Created by Student on 14/10/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class RegisterTableController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var weightGoaldField: UITextField!
    @IBOutlet weak var calorieGoaldField: UITextField!
    
    //pickers
    let picker = UIDatePicker()
    var genderPicker = UIPickerView()
    var heightPicker = UIPickerView()
    var weightPicker = UIPickerView()
    var calorieGoalPicker = UIPickerView()
    var weightgoalPicker = UIPickerView()
    
    //data
    var genderData = ["Female", "Male", "Other"]
    var heightData = [Int]()
    var weightData = [Int]()
    var weightGoaldData = [Int]()
    var calorieGoaldData = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func generateWeightData() -> Array<Int> {
        //declare array
        var weightArray = [Int]()
        
        //add each item in array
        for weight in 25...200 {
            weightArray.append(weight)
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
        } else if(pickerView == heightPicker) {
            heightField.text = String(heightData[row]) + " cm"
        } else if(pickerView == weightPicker) {
            weightField.text = String(weightData[row]) + " kg"
        } else if(pickerView == calorieGoalPicker) {
            calorieGoaldField.text = String(calorieGoaldData[row]) + " kcal"
        } else if(pickerView == weightgoalPicker) {
            weightGoaldField.text = String(weightGoaldData[row]) + " kg"
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
}
