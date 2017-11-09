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
    
    func getAllCaloriesToday() -> Float{
        var caloriesList = [Float]()
        
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        let keyDateFormat = DateFormatter()
        keyDateFormat.dateFormat = "yyyyMMdd"
        
        var keys = [Int]()
        var store = [Int: [Food]]()
        do {
            let foodResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for food in foodResult {
                guard let date = food.date as Date? else {
                    // date is nil, ignore this entry:
                    continue
                }
                let key = Int(keyDateFormat.string(from: NSDate() as Date))!
                if (store[key] == nil) {
                    store[key] = [Food]()
                }
                caloriesList.append(Float(food.calories))
            }

        }
        catch {
            print("Error: \(error)")
        }
        

        return caloriesList.reduce(0, +)
    }
    
    func getAllCarbohydratesToday() -> Float{
        var carbohydratesList = [Float]()
        
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        let keyDateFormat = DateFormatter()
        keyDateFormat.dateFormat = "yyyyMMdd"
        
        var keys = [Int]()
        var store = [Int: [Food]]()
        do {
            let foodResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for food in foodResult {
                guard let date = food.date as Date? else {
                    // date is nil, ignore this entry:
                    continue
                }
                let key = Int(keyDateFormat.string(from: NSDate() as Date))!
                if (store[key] == nil) {
                    store[key] = [Food]()
                }
                carbohydratesList.append(Float(food.carbs))
            }
            
        }
        catch {
            print("Error: \(error)")
        }
        
        
        return carbohydratesList.reduce(0, +)
    }

    func getAllFatsToday() -> Float{
        var fatList = [Float]()
        
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        let keyDateFormat = DateFormatter()
        keyDateFormat.dateFormat = "yyyyMMdd"
        
        var keys = [Int]()
        var store = [Int: [Food]]()
        do {
            let foodResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for food in foodResult {
                guard let date = food.date as Date? else {
                    // date is nil, ignore this entry:
                    continue
                }
                let key = Int(keyDateFormat.string(from: NSDate() as Date))!
                if (store[key] == nil) {
                    store[key] = [Food]()
                }
                fatList.append(Float(food.fat))
            }
            
        }
        catch {
            print("Error: \(error)")
        }
        
        
        return fatList.reduce(0, +)
    }
    
    func getAllProteinToday() -> Float{
        var proteinList = [Float]()
        
        let fetchRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        let keyDateFormat = DateFormatter()
        keyDateFormat.dateFormat = "yyyyMMdd"
        
        var keys = [Int]()
        var store = [Int: [Food]]()
        do {
            let foodResult = try DatabaseController.getContext().fetch(fetchRequest)
            
            for food in foodResult {
                guard let date = food.date as Date? else {
                    // date is nil, ignore this entry:
                    continue
                }
                let key = Int(keyDateFormat.string(from: NSDate() as Date))!
                if (store[key] == nil) {
                    store[key] = [Food]()
                }
                //store[key]?.append(food)
                proteinList.append(Float(food.protein))
            }
            
        }
        catch {
            print("Error: \(error)")
        }
        
        
        return proteinList.reduce(0, +)
    }

}
