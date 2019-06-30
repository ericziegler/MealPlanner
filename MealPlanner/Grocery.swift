//
//  Grocery.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/17/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import Foundation

// MARK: - Constants

let GroceryIdentifierCacheKey = "GroceryIdentifierCacheKey"
let GroceryNameCacheKey = "GroceryNameCacheKey"
let GroceryQuantityCacheKey = "GroceryQuantityCacheKey"
let GroceryStatusCacheKey = "GroceryStatusCacheKey"
let GroceryCategoryCacheKey = "GroceryCategoryCacheKey"
let GroceryIngredientsCacheKey = "GroceryIngredientsCacheKey"
let GroceryRecipeCacheKey = "GroceryRecipeCacheKey"
let GroceryLastMadeCacheKey = "GroceryLastMadeCacheKey"

// MARK: - Enums

enum GroceryStatus: Int {
    case need = 0
    case dontNeed = 1
}

class Grocery: NSObject, NSCoding {
    
    // MARK: - Properties
    
    var identifier = ""
    var name = ""
    var status = GroceryStatus.need
    var quantity = "1"
    var category = GeneralCategory
    var recipe = ""
    var ingredients = [Ingredient]()
    var lastMade: Date?
    
    var isMeal: Bool {
        var result = false        
        if category == BreakfastCategory || category == LunchCategory || category == DinnerCategory {
            result = true
        }
        return result
    }
    
    // MARK: - Init
    
    override init() {
        self.identifier = UUID().uuidString
    }
    
    // MARK: - NSCoding
    
    required init?(coder decoder: NSCoder) {
        if let groceryIdentifier = decoder.decodeObject(forKey: GroceryIdentifierCacheKey) as? String {
            self.identifier = groceryIdentifier
        }
        if let groceryName = decoder.decodeObject(forKey: GroceryNameCacheKey) as? String {
            self.name = groceryName
        }
        if let groceryStatusNumber = decoder.decodeObject(forKey: GroceryStatusCacheKey) as? NSNumber, let groceryStatus = GroceryStatus(rawValue: groceryStatusNumber.intValue) {
            self.status = groceryStatus
        }
        if let groceryQuantity = decoder.decodeObject(forKey: GroceryQuantityCacheKey) as? String {
            self.quantity = groceryQuantity
        }
        if let groceryCategory = decoder.decodeObject(forKey: GroceryCategoryCacheKey) as? String {
            self.category = groceryCategory
        }
        if let groceryRecipe = decoder.decodeObject(forKey: GroceryRecipeCacheKey) as? String {
            self.recipe = groceryRecipe
        }
        if let ingredientsData = decoder.decodeObject(forKey: GroceryIngredientsCacheKey) as? Data, let groceryIngredients = NSKeyedUnarchiver.unarchiveObject(with: ingredientsData) as? [Ingredient]{
            self.ingredients = groceryIngredients
        }
        if let groceryLastMade = decoder.decodeObject(forKey: GroceryLastMadeCacheKey) as? Date {
            self.lastMade = groceryLastMade
        }
    }
    
    public func encode(with coder: NSCoder) {
        let groceryStatusNumber = NSNumber(integerLiteral: self.status.rawValue)
        coder.encode(self.identifier, forKey: GroceryIdentifierCacheKey)
        coder.encode(groceryStatusNumber, forKey: GroceryStatusCacheKey)
        coder.encode(self.name, forKey: GroceryNameCacheKey)
        coder.encode(self.quantity, forKey: GroceryQuantityCacheKey)
        coder.encode(self.category, forKey: GroceryCategoryCacheKey)
        coder.encode(self.recipe, forKey: GroceryRecipeCacheKey)
        let ingredientsData = NSKeyedArchiver.archivedData(withRootObject: self.ingredients)
        coder.encode(ingredientsData, forKey: GroceryIngredientsCacheKey)
        coder.encode(self.lastMade, forKey: GroceryLastMadeCacheKey)
    }
    
    // MARK: - Convenience Functions
    
    func formattedLastMadeDate() -> String {        
        var result = "Never Made"
        if let lastMade = self.lastMade, lastMade != Date.init(timeIntervalSince1970: 0) {
            let formatter = DateFormatter()
            formatter.dateFormat = "M/d/yyyy"
            result = "Last Made: \(formatter.string(from: lastMade))"
        }
        return result
    }
    
}
