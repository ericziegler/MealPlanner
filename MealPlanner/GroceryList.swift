//
//  GroceryList.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/17/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import Foundation

// MARK: - Constants

let GroceryListCacheKey = "GroceryListCacheKey"
let GeneralCategory = "General"

class GroceryList {
    
    // MARK: - Properties
    
    var groceries: [Grocery] = []
    
    // MARK: - Init
    
    static let shared = GroceryList()
    
    init() {
        self.loadGroceries()
    }
    
    // MARK: - Loading
    
    func loadGroceries() {
        if let groceryListData = UserDefaults.standard.data(forKey: GroceryListCacheKey) {
            if let groceries = NSKeyedUnarchiver.unarchiveObject(with: groceryListData) as? [Grocery] {
                self.groceries = groceries
            }
        }
    }
    
    func clearGroceriesFromCache() {
        self.groceries.removeAll()
        let groceryListData = NSKeyedArchiver.archivedData(withRootObject: self.groceries)
        UserDefaults.standard.set(groceryListData, forKey: GroceryListCacheKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Saving
    
    func saveGroceriesToCache() {
        let groceryListData = NSKeyedArchiver.archivedData(withRootObject: self.groceries)
        UserDefaults.standard.set(groceryListData, forKey: GroceryListCacheKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Convenience Functions
    
    func checkForValidCategory(category: String) {
        for curGrocery in self.groceries {
            if curGrocery.category == category {
                curGrocery.category = GeneralCategory
            }
        }
        self.saveGroceriesToCache()
    }
    
    func groceriesForCategory(category: String) -> [Grocery] {
        var result = [Grocery]()
        for curGrocery in groceries {
            if curGrocery.category == category {
                result.append(curGrocery)
            }
        }
        return result
    }
    
}
