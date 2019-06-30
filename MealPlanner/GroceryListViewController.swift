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
        if let addImage = UIImage(named: "Add")?.maskedImageWithColor(UIColor.navAccent), let filterImage = UIImage(named: "Filter")?.maskedImageWithColor(UIColor.navAccent) {
            let addButton = UIButton(type: .custom)
            addButton.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
            addButton.setImage(addImage, for: .normal)
            addButton.frame = CGRect(x: 0, y: 0, width: addImage.size.width, height: addImage.size.height)
            let addItem = UIBarButtonItem(customView: addButton)
            
            let filterButton = UIButton(type: .custom)
            filterButton.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
            filterButton.setImage(filterImage, for: .normal)
            filterButton.frame = CGRect(x: 0, y: 0, width: filterImage.size.width, height: filterImage.size.height)
            let filterItem = UIBarButtonItem(customView: filterButton)
            
            self.navigationItem.rightBarButtonItems = [addItem, filterItem]
        }
        
        if let shareImage = UIImage(named: "Share")?.maskedImageWithColor(UIColor.navAccent) {
            let shareButton = UIButton(type: .custom)
            shareButton.addTarget(self, action: #selector(shareTapped(_:)), for: .touchUpInside)
            shareButton.setImage(shareImage, for: .normal)
            shareButton.frame = CGRect(x: 0, y: 0, width: shareImage.size.width, height: shareImage.size.height)
            let shareItem = UIBarButtonItem(customView: shareButton)
            
            self.navigationItem.leftBarButtonItems = [shareItem]
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: AnyObject) {
        self.displayGrocery(grocery: nil)
    }
    
    @IBAction func filterTapped(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Filter Groceries By", message: nil, preferredStyle: .actionSheet)
        let categoryAction = UIAlertAction(title: "Category", style: .default) { (action) in
            self.groceryList.filterType = .category
            self.updateFilter()
        }
        let dateAction = UIAlertAction(title: "Last Made", style: .default) { (action) in
            self.groceryList.filterType = .lastMade
            self.updateFilter()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(categoryAction)
        actionSheet.addAction(dateAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func shareTapped(_ sender: AnyObject) {
        let items = [groceryList.formattedShareText]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    private func displayGrocery(grocery: Grocery?) {
        DispatchQueue.main.async {
            let groceryViewController = GroceryViewController.createControllerFor(grocery: grocery)
            let navController = BaseNavigationController(rootViewController: groceryViewController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    private func updateFilter() {
        groceryList.saveGroceriesToCache()
        self.groceriesTable.reloadData()
    }
    
}

extension GroceryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if groceryList.filterType == .lastMade {
            return 1
        }
        return categoryList.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groceryList.filterType == .lastMade {
            return groceryList.sortedLastMade().count
        } else {
            let category = categoryList.categories[section]
            return groceryList.groceriesForCategory(category: category).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var grocery: Grocery!
        if groceryList.filterType == .lastMade {
            grocery = groceryList.sortedLastMade()[indexPath.row]
        } else {
            let category = categoryList.categories[indexPath.section]
            grocery = groceryList.groceriesForCategory(category: category)[indexPath.row]
        }
        let groceryCell: GroceryCell = tableView.dequeueReusableCell(withIdentifier: GroceryCellId, for: indexPath as IndexPath) as! GroceryCell
        groceryCell.delegate = self
        groceryCell.indexPath = indexPath
        groceryCell.layoutFor(grocery: grocery)
        return groceryCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if groceryList.filterType == .category && groceryList.groceriesForCategory(category: categoryList.categories[section]).count > 0 {
            return categoryList.categories[section]
        }
        return nil;
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var grocery: Grocery!
        if groceryList.filterType == .lastMade {
            grocery = groceryList.sortedLastMade()[indexPath.row]
        } else {
            let category = categoryList.categories[indexPath.section]
            grocery = groceryList.groceriesForCategory(category: category)[indexPath.row]
        }
        self.displayGrocery(grocery: grocery)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Remove Item", message: "Are you sure you would like to remove this grocery item?", preferredStyle: .alert)
            let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (action) in
                var grocery: Grocery!
                if self.groceryList.filterType == .lastMade {
                    var sortedGroceryList = self.groceryList.sortedLastMade()
                    grocery = sortedGroceryList[indexPath.row]
                    if let index = sortedGroceryList.index(of: grocery) {
                        sortedGroceryList.remove(at: index)
                    }
                } else {
                    let category = self.categoryList.categories[indexPath.section]
                    grocery = self.groceryList.groceriesForCategory(category: category)[indexPath.row]
                    if let index = self.groceryList.groceries.index(of: grocery) {
                        self.groceryList.groceries.remove(at: index)
                    }
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
