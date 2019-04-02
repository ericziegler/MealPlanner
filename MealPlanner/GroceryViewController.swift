//
//  GroceryViewController.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/17/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit
import WebKit

// MARK: - Constants

let GroceryViewId = "GroceryViewId"

class GroceryViewController: BaseViewController {

    // MARK: - Properties
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewContentView: UIView!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var categoryLabel: LightLabel!
    @IBOutlet var addUpdateRecipeButton: UIButton!
    @IBOutlet var recipeView: WKWebView!
    
    var grocery: Grocery!
    var isNewGrocery = false
    let numberToolbar: UIToolbar = UIToolbar()
    
    // MARK: - Init
    
    class func createControllerFor(grocery: Grocery?) -> GroceryViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: GroceryViewController = storyboard.instantiateViewController(withIdentifier: GroceryViewId) as! GroceryViewController
        viewController.grocery = grocery        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if grocery == nil {
            grocery = Grocery()
            isNewGrocery = true
        }
        self.setupForGrocery()
        self.setupTextFields()
        self.setupNavBar()
        self.setupRecipeView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateRecipeView()
        self.setupCategory()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Grocery"
        var addSaveText = "Add"
        if isNewGrocery == false {
            addSaveText = "Update"
        }
        let addSaveItem = UIBarButtonItem(title: addSaveText, style: .plain, target: self, action: #selector(addSaveTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addSaveItem]
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped(_:)))
        self.navigationItem.leftBarButtonItems = [cancelItem]
    }
    
    private func setupTextFields() {
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.nameTextField.frame.size.height))
        nameTextField.leftView = namePaddingView
        nameTextField.leftViewMode = .always

        quantityTextField.layer.borderColor = UIColor.lightGray.cgColor
        quantityTextField.layer.borderWidth = 1
        let quantityPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.quantityTextField.frame.size.height))
        quantityTextField.leftView = quantityPaddingView
        quantityTextField.leftViewMode = .always
        
        numberToolbar.barStyle = .default
        let quantityDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(quantityDoneTapped(_:)))
        numberToolbar.items=[
            quantityDoneButton
        ]
        numberToolbar.sizeToFit()
        quantityTextField.inputAccessoryView = numberToolbar
    }
    
    private func setupForGrocery() {
        self.nameTextField.text = grocery.name
        self.quantityTextField.text = String(grocery.quantity)
        self.setupCategory()
    }
    
    private func setupCategory() {
        if grocery.category == GeneralCategory {
            self.categoryLabel.text = "Category"
        } else {
            self.categoryLabel.text = grocery.category
        }
    }
    
    private func setupRecipeView() {
        self.recipeView.layer.borderColor = UIColor.lightGray.cgColor
        self.recipeView.layer.borderWidth = 1
        self.edgesForExtendedLayout = []
    }
    
    private func updateRecipeView() {
        if let grocery = self.grocery, grocery.recipe.count > 0 {
            if let url = URL(string: grocery.recipe) {
                let request = URLRequest(url: url)                
                recipeView.isHidden = false
                recipeView.load(request)
                addUpdateRecipeButton.setTitle("Update link for recipe", for: .normal)
                let attributes = [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
                    NSAttributedString.Key.foregroundColor : UIColor.main,
                    NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
                
                let attributedString = NSMutableAttributedString()
                attributedString.append(NSAttributedString(string: "Update link for recipe",
                                                           attributes: attributes))
                addUpdateRecipeButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }
    
    @IBAction func quantityDoneTapped(_ sender: AnyObject) {
        if let quantity = quantityTextField.text, quantity.count > 0 {
            grocery?.quantity = quantity
        }
        self.view.endEditing(true)
    }
    
    @IBAction func addRecipeTapped(_ sender: AnyObject) {
        let recipeViewController = RecipeViewController.createControllerFor(grocery: grocery!)
        let navController = BaseNavigationController(rootViewController: recipeViewController)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func addSaveTapped(_ sender: AnyObject) {
        var alertMessage = ""
        if self.nameTextField.text!.count == 0 {
            alertMessage = "You cannot save unless the item has a name."
        }
        else if self.quantityTextField.text!.count == 0 {
            alertMessage = "You cannot save unless the item has a quantity."
        } else {
            if self.isNewGrocery == true {
                self.grocery = Grocery()
                GroceryList.shared.groceries.append(self.grocery!)
            }
            self.grocery.quantity = self.quantityTextField.text!
            self.grocery.name = self.nameTextField.text!
            if self.categoryLabel.text! != "Category" {
                self.grocery.category = categoryLabel.text!
            } else {
                self.grocery.category = GeneralCategory
            }
            GroceryList.shared.saveGroceriesToCache()
        }
        if alertMessage.count == 0 {
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Whoopsie!", message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got It", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryTapped(_ sender: AnyObject) {
        let categoriesViewController = CategoriesViewController.createControllerFor(grocery: self.grocery)
        categoriesViewController.delegate = self
        self.navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
}

extension GroceryViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

extension GroceryViewController: CategoriesViewControllerDelegate {
    
    func categoryWasSelected(category: String, forController: CategoriesViewController) {
        grocery.category = category
        categoryLabel.text = category
    }
    
}
