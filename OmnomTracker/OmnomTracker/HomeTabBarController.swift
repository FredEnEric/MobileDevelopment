//
//  HomeViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 10/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController, UIPickerViewDataSource, UIPickerViewDelegate {
    //var
    @IBOutlet weak var weightField: UITextField!
    var weight = Float(0.0)
    
    //picker
    var weightPicker = UIPickerView()
    
    //view
    var blurEffectView: UIVisualEffectView!
    
    //data
    var weightData = [Float]()
    
    //@IBOutlet weak var weightField: UITextField!
    @IBOutlet var logWeightView: UIView!
    @IBAction func logWeightButton(_ sender: Any){
        if(weight != 0.0){
            putLogWeightInDatabase()
        }
        animateOut()
    }

    func putLogWeightInDatabase() {
        var logRepo = LogRepository()
        var logModel = LogModel()
        logModel.weight = weight

        
        //save food in repo
        logRepo.add(model: logModel)
    }

    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.logWeightView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.logWeightView.alpha = 0
            self.blurEffectView.effect = nil
            self.blurEffectView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }, completion: { (finished: Bool) in
            self.logWeightView.removeFromSuperview()
        })

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
    
    
    @objc func donePressing(){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightData = generateWeightData()
        
        craetePicker(field: weightField, picker: weightPicker)
        
        // Do any additional setup after loading the view.
        /*
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Today"
        self.navigationItem.backBarButtonItem = UIBarButtonItem()
        self.navigationItem.backBarButtonItem?.title = "Cancel"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.title = "Log Weight"
 */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Today"
        self.navigationItem.backBarButtonItem = UIBarButtonItem()
        self.navigationItem.backBarButtonItem?.title = "Cancel"
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Weight", style: .plain, target: self, action: #selector(logWeight))
        
    }
    
    func addBlurToView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    
    
    func logWeight() {
        addBlurToView()
        
        logWeightView.layer.cornerRadius = 5
        self.view.addSubview(logWeightView)
        logWeightView.center = self.view.center
        logWeightView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        logWeightView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.logWeightView.alpha = 1
            self.logWeightView.transform = CGAffineTransform.identity
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.setHidesBackButton(false, animated: false)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weightField.text = String(weightData[row]) + " kg"
        weight = Float(weightData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(weightData[row]) + " kg"
    }

    
}
