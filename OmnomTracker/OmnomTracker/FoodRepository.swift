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
        food.calories = model.calories
        food.carbs = model.carbs
        food.protein = model.protein
        food.fat = model.fat
        food.lunch = model.lunch
        food.date = model.date
        food.portions = model.portions
        DatabaseController.saveContext()
    }
    
    func getAll() -> Array<Food>{
      
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        do {
            return try DatabaseController.getContext().fetch(fetchRequest)
        }
        catch {
            print("Error: \(error)")
        }
        
        return [Food]()
    }
    
    func getFoodToday() -> [Food] {
        let allFoods = getAll()
        var foodToday = [Food]()
        
        let keyDateFormat = DateFormatter()
        keyDateFormat.dateFormat = "yyyyMMdd"
        let key = keyDateFormat.string(from: NSDate() as Date)
        
        for food in allFoods {
            if let date = food.date as Date? {
                if key == keyDateFormat.string(from: date) {
                    foodToday.append(food)
                }
            }
        }
        return foodToday
    }
    
    func getFoodTitle(foodtype: Int32) -> Array<String> {
        let foods = getFoodToday()
        var foodList = [String]()
        
        for food in foods {
            if(food.name?.isEmpty == false && food.lunch == foodtype){
                foodList.append(food.name!)
            }
        }

        return foodList
    }

}
