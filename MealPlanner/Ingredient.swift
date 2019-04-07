//
//  Ingredient.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 4/7/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import Foundation

// MARK: - Constants

let IngredientNameCacheKey = "IngredientNameCacheKey"

class Ingredient: NSObject, NSCoding {

    // MARK: - Properties
    
    var name = ""
    
    // MARK: - NSCoding
    
    required init?(coder decoder: NSCoder) {
        if let ingredientName = decoder.decodeObject(forKey: IngredientNameCacheKey) as? String {
            self.name = ingredientName
        }
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: IngredientNameCacheKey)
    }
    
}
