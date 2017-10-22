//
//  FoodRepository.swift
//  OmnomTracker
//
//  Created by Sinasi Yilmaz on 22/10/17.
//  Copyright © 2017 PXL. All rights reserved.
//

import Foundation
import CoreData

class FoodRepository {
    var food: Food = NSEntityDescription.insertNewObject(forEntityName: "Food", into: DatabaseController.persistentContainer.viewContext) as! Food
    
    func add(model: FoodModel) {

        food.name = model.name
        /*
         food.calories = Int32(caloriesLabel.text!)!
         food.carbs = Float(carbGramsLabel.text!)!
         food.protein = Float(proteinGramsLabel.text!)!
         food.fat = Float(fatGramsLabel.text!)!
         */
        //dit moet achteraf als frederic api werkend heeft gekregen vervangen worden door hierboven.
        food.calories = 10
        food.carbs = 10
        food.protein = 10
        food.fat = 10
        food.lunch = model.lunch
        DatabaseController.saveContext()
        print("ok")
    }
}
