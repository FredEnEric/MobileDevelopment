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
                    print(fbDetails)
                }
            })
        }
        
        /*
        let user: User = NSEntityDescription.insertNewObject(forEntityName: "User", into: DatabaseController.persistentContainer.viewContext) as! User
        //user.dateOfBirth = dat;
        
        //save user in DB
        DatabaseController.saveContext()
        
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        
        //cleaner code (DatabaseController.getContext)
        do {
            let searchResult = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of results: \(searchResult.count)")
            
            for result in searchResult as [User]{
                    print("Date of Birth: \(String(describing: result.dateOfBirth))")
            }
        }
        catch {
            print("Error: \(error)")
        }
        
        */
        
    }
    
    func fetchProfile(){
        print("fech profile")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }


}

