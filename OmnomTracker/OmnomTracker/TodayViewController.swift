//
//  ViewMealViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 22/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit
import SwiftCharts
class TodayViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var foodRepo = FoodRepository()
    var userRepo = UserRepository()
    var foodList = [String]()
    
    let kHeaderSectionTag: Int = 6900;
    
    @IBOutlet weak var tableView: UITableView!
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = [ "Breakfast", "Lunch", "Dinner", "Snacks", "Drinks" ]
    
    //var
    @IBOutlet var logWeightView: UIView!
    @IBOutlet weak var weightField: UITextField!
    var weight = Float(0.0)
    var food = Food()
    var user = User()
    
    @IBOutlet weak var progresBarView: UIProgressView!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    //picker
    var weightPicker = UIPickerView()
    
    //view
    var blurEffectView: UIVisualEffectView!
    
    //data
    var weightData = [Float]()

    @IBAction func logWeightButton(_ sender: Any) {
        if(weight != 0){
            putLogWeightInDatabase()
        }
        animateOut()
    }
    @IBOutlet weak var day: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        
        tableView.delegate = self
        tableView.dataSource = self

        self.tableView!.tableFooterView = UIView()
        
        weightData = generateWeightData()
        craetePicker(field: weightField, picker: weightPicker)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Weight", style: .plain, target: self, action: #selector(logWeight))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = userRepo.get()
        let foods = foodRepo.getFoodToday()
        var sumCalories : Int32 = 0
        var sumCarbs : Float = 0
        var sumFats : Float = 0
        var sumProteins : Float = 0
        
        for food in foods {
            sumCalories += Int32(food.portions) * food.calories
            sumCarbs += Float(food.portions) * food.carbs
            sumFats += Float(food.portions) * food.fat
            sumProteins += Float(food.portions) * food.protein
        }
        
        carbsLabel.text = String(Int32(sumCarbs.rounded())) + " grams"
        fatLabel.text = String(Int32(sumFats.rounded())) + " grams"
        proteinLabel.text = String(Int32(sumProteins.rounded())) + " grams"

        if(sumCalories < Int32(user.calorieGoal)){
            progresBarView.progress = Float(sumCalories) / Float(user.calorieGoal)
        }
        else {
            progresBarView.progress = 1
        }

        sectionItems = [ foodRepo.getFoodTitle(foodtype: 0), foodRepo.getFoodTitle(foodtype: 1), foodRepo.getFoodTitle(foodtype: 2), foodRepo.getFoodTitle(foodtype: 3), foodRepo.getFoodTitle(foodtype: 4) ] 
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchTableViewController = segue.destination as! SearchTableViewController
        searchTableViewController.lunch = Int32(Lunch.breakfast.rawValue)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sectionNames.count != 0) {
            return self.sectionNames[section] as? String
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.colorWithHexString(hexStr: "#408000")
        header.textLabel?.textColor = UIColor.white
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "dropdown")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(TodayViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
        
        // give headers a border
        header.layer.borderWidth = 2.0
        header.layer.borderColor = UIColor.white.cgColor
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
        let section = self.sectionItems[indexPath.section] as! NSArray
        print(section)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = section[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    
    func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
        }
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
    
    func addBlurToView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
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
    
    
    func putLogWeightInDatabase() {
        let logRepo = LogRepository()
        let logModel = LogModel()
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
}
