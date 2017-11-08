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

    var user = UserModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        if AccessToken.current != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, gender, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let fbDetails = result as! NSDictionary

                    self.user.gender = fbDetails["gender"] as? String
                    self.user.gender = self.user.gender?.capitalized
                    self.user.firstName = fbDetails["first_name"] as? String
                    self.user.profilePicUrl = ((fbDetails["picture"] as! NSDictionary)["data"] as! NSDictionary)["url"] as? String
                    
                    self.performSegue(withIdentifier: "registerSegue", sender: self)
                }
            })
        }

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
        let registerTableController = segue.destination as! RegisterTableController
        registerTableController.user = self.user
    }
}


