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

    var mealName = "Omnomnom"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mealNameLabel.text = mealName
    }


}
