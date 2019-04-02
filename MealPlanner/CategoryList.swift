//
//  CategoryList.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/31/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import Foundation

// MARK: - Constants

let CategoryListCacheKey = "CategoryListCacheKey"

class CategoryList {
    
    // MARK: - Properties
    
    var categories: [String] = []
    
    // MARK: - Init
    
    static let shared = CategoryList()
    
    init() {
        self.loadCategories()
    }
    
    // MARK: - Loading
    
    private func loadCategories() {
        if let categoryListData = UserDefaults.standard.data(forKey: CategoryListCacheKey) {
            if let categories = NSKeyedUnarchiver.unarchiveObject(with: categoryListData) as? [String] {
                self.categories = categories
            }
        }
        // add a "General" category if there are no categories
        if self.categories.count == 0 {
            self.categories.append("General")
            self.categories.append("Breakfast")
            self.categories.append("Lunch")
            self.categories.append("Dinner")
            self.categories.append("Snacks")
            self.saveCategoriesToCache()
        }
    }
    
    func clearCategoriesFromCache() {
        self.categories.removeAll()
        let categoryListData = NSKeyedArchiver.archivedData(withRootObject: self.categories)
        UserDefaults.standard.set(categoryListData, forKey: CategoryListCacheKey)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: Saving
    
    func saveCategoriesToCache() {
        let categoryListData = NSKeyedArchiver.archivedData(withRootObject: self.categories)
        UserDefaults.standard.set(categoryListData, forKey: CategoryListCacheKey)
        UserDefaults.standard.synchronize()
    }
    
}

