//
//  User+CoreDataProperties.swift
//  
//
//  Created by Sinasi Yilmaz on 8/10/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var dateOfBirth: String?

}
