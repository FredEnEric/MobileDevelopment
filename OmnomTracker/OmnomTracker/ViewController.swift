//
//  ViewController.swift
//  OmnomTracker
//
//  Created by Student on 03/10/2017.
//  Copyright © 2017 PXL. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import CoreData

class ViewController: UIViewController{

    @NSManaged var date: NSDate?
    @IBOutlet weak var userName: UITextField!
    
    var gender = String()
    var userId = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        if AccessToken.current != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let fbDetails = result as! NSDictionary
                    
                    //let idD = fbDetails["id"]
                    let genderD = fbDetails["gender"]
                    //self.userId = idD as! Int
                    self.gender = genderD as! String
                    //self.gender = self.gender.uppercased()
                    print(fbDetails)
                }
            })
        }

    }
    
    func fetchProfile(){
        print("fech profile")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let registerTableController = segue.destination as! RegisterViewController
        //registerTableController.genderString = gender
    }
}


