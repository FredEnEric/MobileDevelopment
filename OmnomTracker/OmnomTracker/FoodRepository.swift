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
        var foodList = [Food]()
        
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        do {
            let foodResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for food in foodResult as [Food]{
                foodList.append(food)
            }
        }
        catch {
            print("Error: \(error)")
        }

        return foodList
    }
    
    func getFoodTitle(foodtype: Int32) -> Array<String> {
        var foodList = [String]()
        
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        do {
            let foodResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for food in foodResult as [Food]{
                if(food.name?.isEmpty == false && food.lunch == foodtype){
                    foodList.append(food.name!)
                }
                
            }
        }
        catch {
            print("Error: \(error)")
        }
        
        return foodList
    }
    
    func getAllToday() -> Array<Food>{
        var foodList = [Food]()
        
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        do {
            let foodResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for food in foodResult as [Food]{
                //if(NSDate(food.date) == NSDate(Calendar.current)){
                    foodList.append(food)
                //}
            }
        }
        catch {
            print("Error: \(error)")
        }
        
        return foodList
    }
}
