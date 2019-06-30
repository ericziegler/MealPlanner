//
//  CategoriesViewController.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/31/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let CategoriesViewId = "CategoriesViewId"

// NARK: - Protocol

protocol CategoriesViewControllerDelegate {
    func categoryWasSelected(category: String, forController: CategoriesViewController)
}

class CategoriesViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet var categoriesTable: UITableView!
    var grocery: Grocery!
    var delegate: CategoriesViewControllerDelegate?
    private var selectedCategory = GeneralCategory
    
    // MARK: - Init
    
    class func createControllerFor(grocery: Grocery?) -> CategoriesViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: CategoriesViewController = storyboard.instantiateViewController(withIdentifier: CategoriesViewId) as! CategoriesViewController
        viewController.grocery = grocery
        if grocery != nil {
            viewController.selectedCategory = grocery!.category
        }
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTable.rowHeight = GroceryListCellHeight
        setupNavBar()
    }
    
    private func setupNavBar() {
        // TODO: EZ - Decide whether allowing new categories should be an option
//        self.navigationItem.title = "Categories"
//        let addSaveItem = UIBarButtonItem(title: "New Category", style: .plain, target: self, action: #selector(addTapped(_:)))
//        self.navigationItem.rightBarButtonItems = [addSaveItem]
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        alert.addTextField { (categoryField) in
            categoryField.placeholder = "Category"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak alert] _ in
            guard let alertController = alert, let textField = alertController.textFields?.first, let category = textField.text else { return }
            CategoryList.shared.categories.append(category)
            self.grocery.category = category
            self.categoriesTable.reloadData()
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryList.shared.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = CategoryList.shared.categories[indexPath.row]
        let categoryCell: CategoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryCellId, for: indexPath as IndexPath) as! CategoryCell
        var isSelected = false
        if category == selectedCategory {
            isSelected = true
        }
        categoryCell.layoutForCategory(category: category, selected: isSelected)
        return categoryCell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        grocery.category = CategoryList.shared.categories[indexPath.row]
        GroceryList.shared.saveGroceriesToCache()
        selectedCategory = CategoryList.shared.categories[indexPath.row]
        delegate?.categoryWasSelected(category: selectedCategory, forController: self)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  && indexPath.row > 0 {
            let alert = UIAlertController(title: "Delete Category", message: "Are you sure you would like to remove this category?", preferredStyle: .alert)
            let removeAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                let category = CategoryList.shared.categories[indexPath.row]
                CategoryList.shared.categories.remove(at: indexPath.row)
                self.grocery?.category = GeneralCategory
                CategoryList.shared.saveCategoriesToCache()
                GroceryList.shared.checkForValidCategory(category: category)
                tableView.reloadData()
            }
            alert.addAction(removeAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
