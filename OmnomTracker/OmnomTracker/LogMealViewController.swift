//
//  LogMealViewController.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 10/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

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
    var mealId = "not set"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mealNameLabel.text = mealName
    }


}
