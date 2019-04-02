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
let GroceryRecipeCacheKey = "GroceryRecipeCacheKey"

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
    }
    
    public func encode(with coder: NSCoder) {
        let groceryStatusNumber = NSNumber(integerLiteral: self.status.rawValue)
        coder.encode(self.identifier, forKey: GroceryIdentifierCacheKey)
        coder.encode(groceryStatusNumber, forKey: GroceryStatusCacheKey)
        coder.encode(self.name, forKey: GroceryNameCacheKey)
        coder.encode(self.quantity, forKey: GroceryQuantityCacheKey)
        coder.encode(self.category, forKey: GroceryCategoryCacheKey)
        coder.encode(self.recipe, forKey: GroceryRecipeCacheKey)
    }
    
}
