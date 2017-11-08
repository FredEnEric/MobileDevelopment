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
        if(log.weight != 0){
            DatabaseController.saveContext()
        }
    }
    
    func getAllLogs() -> Array<Float> {
        var logList = [Float]()
        
        let fetchRequest:NSFetchRequest<Log> = Log.fetchRequest()
        
        do {
            let logResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for log in logResult as [Log]{
                if(log.weight != 0){
                    logList.append(log.weight)
                }
            }
        }
        catch {
            print("Error: \(error)")
        }
        
        return logList
    }

}
