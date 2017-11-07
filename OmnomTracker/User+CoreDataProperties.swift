//
//  User+CoreDataProperties.swift
//  
//
//  Created by Sinasi Yilmaz on 16/10/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var calorieGoal: Int16
    @NSManaged public var gender: String?
    @NSManaged public var height: Float
    @NSManaged public var userId: Int32
    @NSManaged public var weight: Float
    @NSManaged public var weightGoal: Float
    @NSManaged public var dateBirth: NSDate
    @NSManaged public var firstName: String?
    @NSManaged public var profilePicUrl: String?

}
