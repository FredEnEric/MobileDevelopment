//
//  Food+CoreDataProperties.swift
//  
//
//  Created by Sinasi Yilmaz on 16/10/17.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var apiId: Int32
    @NSManaged public var calories: Int32
    @NSManaged public var carbs: Float
    @NSManaged public var date: NSDate?
    @NSManaged public var fat: Float
    @NSManaged public var meal: String?
    @NSManaged public var name: String?
    @NSManaged public var portions: Int16
    @NSManaged public var protein: Float
    @NSManaged public var lunch: Int32
}
