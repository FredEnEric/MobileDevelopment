//
//  UserRepository.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 22/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import Foundation
import CoreData

class UserRepository {
    var user: User = NSEntityDescription.insertNewObject(forEntityName: "User", into: DatabaseController.persistentContainer.viewContext) as! User
    
    func add(model: UserModel) {
        user.calorieGoal = model.calorieGoal
        //user.dateBirth = model.dateBirth!
        user.firstName = model.firstName
        user.gender = model.gender
        user.height = model.height
        user.profilePicUrl = model.profilePicUrl
        user.userId = model.userId
        user.weight = model.weight
        user.weightGoal = model.weightGoal
        DatabaseController.saveContext()
    }
    
    func get() -> User{
        var user = User()
        
        let fetchRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let results = try DatabaseController.getContext().fetch(fetchRequest)
            for result in results {
                if(result.userId != 0){
                    user = result
                    break
                }
            }
        }
        catch {
            print("Error: \(error)")
        }
        
        return user
    }
}
