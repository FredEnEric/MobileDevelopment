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
        /*
        do {
            let searchResult = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of results: \(searchResult.count)")
            
            for result in searchResult as [User]{
                print("Height: \(String(describing: result.height))")
            }
        }
        catch {
            print("Error: \(error)")
        }
         */

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
}
