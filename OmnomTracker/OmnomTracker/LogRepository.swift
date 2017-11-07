//
//  LogRepository.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 7/11/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import Foundation
import CoreData

class LogRepository {
    var log: Log = NSEntityDescription.insertNewObject(forEntityName: "Log", into: DatabaseController.persistentContainer.viewContext) as! Log
    
    func add(model: LogModel) {
        log.weight = model.weight
        DatabaseController.saveContext()
    }
}
