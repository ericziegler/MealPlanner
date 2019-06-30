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

// MARK: - Enums

enum GroceryFilter: Int {
    case category
    case lastMade
}

class GroceryList {
    
    // MARK: - Properties
    
    var groceries: [Grocery] = []
    var filterType: GroceryFilter = .category
    var formattedShareText: String {
        var result = ""
        
        var generalGroceries = [Grocery]()
        var breakfastGroceries = [Grocery]()
        var lunchGroceries = [Grocery]()
        var dinnerGroceries = [Grocery]()
        var snackGroceries = [Grocery]()
        
        for curGrocery in groceries {
            if curGrocery.status == .need {
                if curGrocery.category == GeneralCategory {
                    generalGroceries.append(curGrocery)
                }
                else if curGrocery.category == BreakfastCategory {
                    breakfastGroceries.append(curGrocery)
                }
                else if curGrocery.category == LunchCategory {
                    lunchGroceries.append(curGrocery)
                }
                else if curGrocery.category == DinnerCategory {
                    dinnerGroceries.append(curGrocery)
                }
                else if curGrocery.category == SnackCategory {
                    snackGroceries.append(curGrocery)
                }
            }
        }
        
        if generalGroceries.count > 0 {
            result += "\(GeneralCategory.uppercased())\n"
            result += formattedShareGroceriesFor(categoryGroceries: generalGroceries)
        }
        if breakfastGroceries.count > 0 {
            result += "\(BreakfastCategory.uppercased())\n"
            result += formattedShareGroceriesFor(categoryGroceries: breakfastGroceries)
        }
        if lunchGroceries.count > 0 {
            result += "\(LunchCategory.uppercased())\n"
            result += formattedShareGroceriesFor(categoryGroceries: lunchGroceries)
        }
        if dinnerGroceries.count > 0 {
            result += "\(DinnerCategory.uppercased())\n"
            result += formattedShareGroceriesFor(categoryGroceries: dinnerGroceries)
        }
        if snackGroceries.count > 0 {
            result += "\(SnackCategory.uppercased())\n"
            result += formattedShareGroceriesFor(categoryGroceries: snackGroceries)
        }
        
        return result
    }
    
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
        var noDateGroceries = [Grocery]()
        // only sort groceries that have a lastMade date
        for curGrocery in groceries {
            if let _ = curGrocery.lastMade {
                result.append(curGrocery)
            }
            else if curGrocery.isMeal == true {
                noDateGroceries.append(curGrocery)
            }
        }
        // sort
        result = result.sorted(by: { $0.lastMade!.compare($1.lastMade!) == .orderedDescending })
        // add grocieries with no lastMade date
        noDateGroceries = noDateGroceries.sorted { $0.name < $1.name }
        result += noDateGroceries
        
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
    
    private func formattedShareGroceriesFor(categoryGroceries: [Grocery]) -> String {
        var result = ""
        
        for curGrocery in categoryGroceries {
            if curGrocery.status == .need {
                result += "- "
                if curGrocery.quantity != "1" {
                    result += "\(curGrocery.quantity)x "
                }
                result += "\(curGrocery.name)"
                if curGrocery.recipe.count > 0 {
                    result += "- \n\(curGrocery.recipe)"
                }
                result += "\n"
            }
        }
        result += "\n"
        
        return result
    }
    
}
