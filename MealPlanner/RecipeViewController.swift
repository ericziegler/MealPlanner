//
//  RecipeViewController.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 4/1/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit
import WebKit

// MARK: - Constants

let RecipeViewId = "RecipeViewId"

class RecipeViewController: BaseViewController {

    // MARK: - Properties
    
    @IBOutlet var recipeView: WKWebView!
    var recipeURLString: String?
    
    var grocery: Grocery!
    
    // MARK: - Init
    
    class func createControllerFor(grocery: Grocery) -> RecipeViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: RecipeViewController = storyboard.instantiateViewController(withIdentifier: RecipeViewId) as! RecipeViewController
        viewController.grocery = grocery
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.loadRecipe()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Recipe"
        var addSaveText = "Add"
        if grocery.recipe.count > 0 {
            addSaveText = "Update"
        }
        let addSaveItem = UIBarButtonItem(title: addSaveText, style: .plain, target: self, action: #selector(addSaveTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addSaveItem]
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        self.navigationItem.leftBarButtonItems = [cancelItem]
    }
    
    private func loadRecipe() {
        let groceryURL = URL(string: "https://google.com")
        let request = URLRequest(url: groceryURL!)
        recipeView.load(request)
    }
    
    // MARK: - Actions
    
    @IBAction func addSaveTapped(_ sender: AnyObject) {
        if let recipeURLString = self.recipeView.url?.absoluteString {
            grocery.recipe = recipeURLString
            GroceryList.shared.saveGroceriesToCache()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
