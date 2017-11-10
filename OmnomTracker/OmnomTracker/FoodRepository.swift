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
    
    func getAllCaloriesToday() -> Int32{
        let foods = getFoodToday()
        var caloriesList = [Int32]()
            
        for food in foods {
            print(food.portions)
            caloriesList.append(Int32(food.portions) * food.calories)
        }

        return caloriesList.reduce(0, +)
    }
    
    func getAllCarbohydratesToday() -> Float{
        let foods = getFoodToday()
        var carbohydratesList = [Float]()
        
        for food in foods {
            carbohydratesList.append(Float(food.portions) * food.carbs)
        }
        
        return carbohydratesList.reduce(0, +)
    }

    func getAllFatsToday() -> Float{
        let foods = getFoodToday()
        var fatList = [Float]()
        
        for food in foods {
            fatList.append(Float(food.portions) * food.fat)
        }
        
        return fatList.reduce(0, +)
    }
    
    func getAllProteinToday() -> Float{
        let foods = getFoodToday()
        var proteinList = [Float]()
        
        for food in foods {
            proteinList.append(Float(food.portions) * food.protein)
        }
        
        return proteinList.reduce(0, +)
    }

}
