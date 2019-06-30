//
//  ExpandedRecipeViewController.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 4/7/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit
import WebKit

// MARK: - Constants

let ExpandedRecipeViewId = "ExpandedRecipeViewId"

class ExpandedRecipeViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet var recipeView: WKWebView!
    var recipeURLString: String?
    
    // MARK: - Init
    
    class func createControllerFor(recipe: String) -> ExpandedRecipeViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ExpandedRecipeViewController = storyboard.instantiateViewController(withIdentifier: ExpandedRecipeViewId) as! ExpandedRecipeViewController
        viewController.recipeURLString = recipe
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.loadRecipe()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Recipe"
    }
    
    private func loadRecipe() {
        if let recipe = recipeURLString {
            let recipeURL = URL(string: recipe)
            let request = URLRequest(url: recipeURL!)
            recipeView.load(request)
        }
    }
    
}

