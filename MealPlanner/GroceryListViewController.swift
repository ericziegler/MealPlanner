//
//  GroceryListViewController.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/17/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit

// MARK: - Constants

let GroceryListViewId = "GroceryListViewId"

class GroceryListViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet var groceriesTable: UITableView!
    let groceryList = GroceryList.shared
    let categoryList = CategoryList.shared
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groceriesTable.rowHeight = GroceryListCellHeight
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.groceriesTable.reloadData()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Groceries"
        if let addImage = UIImage(named: "Add")?.maskedImageWithColor(UIColor.navAccent) {
            let addButton = UIButton(type: .custom)
            addButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
            addButton.setImage(addImage, for: .normal)
            addButton.frame = CGRect(x: 0, y: 0, width: addImage.size.width, height: addImage.size.height)
            let addItem = UIBarButtonItem(customView: addButton)
            
            self.navigationItem.rightBarButtonItems = [addItem]
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: AnyObject) {
        self.displayGrocery(grocery: nil)
    }
    
    private func displayGrocery(grocery: Grocery?) {
        DispatchQueue.main.async {
            let groceryViewController = GroceryViewController.createControllerFor(grocery: grocery)
            let navController = BaseNavigationController(rootViewController: groceryViewController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
}

extension GroceryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryList.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = categoryList.categories[section]
        return groceryList.groceriesForCategory(category: category).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryList.categories[indexPath.section]
        let grocery = groceryList.groceriesForCategory(category: category)[indexPath.row]
        let groceryCell: GroceryCell = tableView.dequeueReusableCell(withIdentifier: GroceryCellId, for: indexPath as IndexPath) as! GroceryCell
        groceryCell.delegate = self
        groceryCell.indexPath = indexPath
        groceryCell.layoutFor(grocery: grocery)
        return groceryCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if groceryList.groceriesForCategory(category: categoryList.categories[section]).count > 0 {
            return categoryList.categories[section]
        }
        return nil;
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryList.categories[indexPath.section]
        let grocery = groceryList.groceriesForCategory(category: category)[indexPath.row]
        self.displayGrocery(grocery: grocery)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Remove Item", message: "Are you sure you would like to remove this grocery item?", preferredStyle: .alert)
            let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (action) in
                let category = self.categoryList.categories[indexPath.section]
                let grocery = self.groceryList.groceriesForCategory(category: category)[indexPath.row]
                if let index = self.groceryList.groceries.index(of: grocery) {
                    self.groceryList.groceries.remove(at: index)
                }
                self.groceryList.saveGroceriesToCache()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            alert.addAction(removeAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension GroceryListViewController: GroceryCellDelegate {

    func didChangeGroceryStatus(cell: GroceryCell) {
        groceryList.saveGroceriesToCache()
        if let indexPath = cell.indexPath {
            groceriesTable.beginUpdates()
            groceriesTable.reloadRows(at: [indexPath], with: .automatic)
            groceriesTable.endUpdates()
        }
    }
    
}
