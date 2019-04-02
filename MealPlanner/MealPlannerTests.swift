//
//  MealPlannerTests.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 4/1/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import Foundation

class MealPlannerTests {

    static let shared = MealPlannerTests()
    
    func runTests() {
        let list = GroceryList.shared
        list.clearGroceriesFromCache()
        
        var grocery = Grocery()
        grocery.name = "Bananas"
        grocery.category = "Breakfast"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Pre-cooked bacon"
        grocery.category = "Breakfast"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Eggo buttermilk waffles"
        grocery.category = "Breakfast"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Gatorade"
        grocery.category = GeneralCategory
        
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Small cottage cheese"
        grocery.category = "Breakfast"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Salt & Vinegar chips"
        grocery.category = "Snacks"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Small bag of spinach"
        grocery.category = "Lunch"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Fresh sliced mushrooms"
        grocery.category = "Lunch"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Large can sliced olives"
        grocery.category = "Lunch"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Thick shredded cheddar cheese"
        grocery.category = "Lunch"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Small red onion"
        grocery.category = "Lunch"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Roma tomatoes"
        grocery.quantity = "2"
        grocery.category = "Lunch"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Cucumber"
        grocery.category = "Lunch"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Broccoli & cheese rolls"
        grocery.category = "Dinner"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Quesadillas"
        grocery.category = "Dinner"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Meatloaf"
        grocery.category = "Dinner"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Tacos"
        grocery.category = "Dinner"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Pasta"
        grocery.category = "Dinner"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Thai pineapple fried rice"
        grocery.category = "Dinner"
        //grocery.recipe = "https://leelalicious.com/thai-baked-pineapple-fried-rice/"
        list.groceries.append(grocery)
        
        grocery = Grocery()
        grocery.name = "Black bean burgers"
        grocery.category = "Dinner"
        list.groceries.append(grocery)
        
        list.saveGroceriesToCache()
    }
    
}
