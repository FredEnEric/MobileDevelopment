//
//  ViewController.swift
//  OmnomTracker
//
//  Created by Student on 03/10/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = "PJ"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

