//
//  Log+CoreDataProperties.swift
//  
//
//  Created by Sinasi Yilmaz on 7/11/17.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var weight: Float

}
