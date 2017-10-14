//
//  RegisterViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 8/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var weightGoaldField: UITextField!
    @IBOutlet weak var calorieGoaldField: UITextField!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createDatePicker()
        //createWeightPicker()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func createWeightPicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button for toolbar, action refers to method donePressed().
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedInput))
        toolbar.setItems([done], animated: false)
        
        weightField.inputAccessoryView = toolbar
        weightField.inputView = picker
        
        picker.datePickerMode = .date
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
    
    @objc func donePressedInput(){
        
    }

}
