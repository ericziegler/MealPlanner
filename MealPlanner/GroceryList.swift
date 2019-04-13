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
let GroceryListFilterCacheKey = "GroceryListFilterCacheKey"
let GeneralCategory = "General"

// MARK: - Enums

enum GroceryFilter: Int {
    case category
    case lastMade
}

class GroceryList {
    
    // MARK: - Properties
    
    var groceries: [Grocery] = []
    var filterType: GroceryFilter = .category
    
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
        let filterInt = UserDefaults.standard.integer(forKey: GroceryListFilterCacheKey)
        if let type = GroceryFilter(rawValue: filterInt) {
            filterType = type
        }
    }
    
    // only used for testing
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
        UserDefaults.standard.set(filterType.rawValue, forKey: GroceryListFilterCacheKey)
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
    
    func sortedLastMade() -> [Grocery] {
        var result = [Grocery]()
        // only sort groceries that have ingredients or a recipe url
        for curGrocery in groceries {
            if curGrocery.ingredients.count > 0 || curGrocery.recipe.count > 0 {
                result.append(curGrocery)
            }
        }
        // sort
        result = result.sorted(by: { $0.lastMade.compare($1.lastMade) == .orderedDescending })
        return result
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
