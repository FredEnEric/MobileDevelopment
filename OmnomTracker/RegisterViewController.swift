//
//  RegisterViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 8/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var datePickerTextBox: UITextField!
    
    //array date in date (day, month, year)
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDatePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed)) //selector refers to method donePressed
        
        //put the array in the toolbar
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTextBox.inputAccessoryView = toolbar
        
        // assigning datepicker to textfield
        datePickerTextBox.inputView = datePicker
        
        //format picker for date (day, month, year)
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date) //put dateString later in the DB
        
        datePickerTextBox.text = "\(dateString)"
        self.view.endEditing(true) //check date
    }
}
