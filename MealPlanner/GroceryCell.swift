//
//  GroceryCell.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/17/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let GroceryCellId = "GroceryCellId"
let GroceryListCellHeight: CGFloat = 70.0
let NameLabelLeadingConstraintClose: CGFloat = 8.0
let NameLabelLeadingConstraintFar: CGFloat = 36.0

// MARK: - Protocol

protocol GroceryCellDelegate {
    func didChangeGroceryStatus(cell: GroceryCell)
}

class GroceryCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var groceryNameLabel: RegularLabel!
    @IBOutlet weak var groceryStatusButton: LightButton!
    @IBOutlet weak var groceryDateLabel: LightLabel!
    @IBOutlet weak var groceryNameTopConstraint: NSLayoutConstraint!
    
    var grocery: Grocery?
    var delegate: GroceryCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groceryStatusButton.layer.borderWidth = 1
        groceryStatusButton.layer.cornerRadius = groceryStatusButton.frame.size.height / 2
    }
    
    // MARK: Layout
    
    func layoutFor(grocery: Grocery) {
        self.grocery = grocery
        groceryNameLabel.text = "\(grocery.quantity) \(grocery.name)"
        if grocery.status == .dontNeed {
            groceryStatusButton.setTitle("Don't Need", for: .normal)
            groceryStatusButton.setTitleColor(UIColor.lightGray, for: .normal)
            groceryStatusButton.layer.borderColor = UIColor.lightGray.cgColor
            groceryStatusButton.backgroundColor = UIColor.clear
        }
        else if grocery.status == .need {
            groceryStatusButton.setTitle("Need", for: .normal)
            groceryStatusButton.setTitleColor(UIColor.white, for: .normal)
            groceryStatusButton.layer.borderColor = UIColor.main.cgColor
            groceryStatusButton.backgroundColor = UIColor.main
        }
        if let _ = grocery.lastMade {
            groceryDateLabel.text = grocery.formattedLastMadeDate()
            groceryNameTopConstraint.constant = 20
        } else {
            groceryNameTopConstraint.constant = 0
        }
                
        if let _ = grocery.lastMade {
            groceryDateLabel.isHidden = false
        } else {
            groceryDateLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func statusButtonTapped(_ sender: AnyObject) {
        if grocery?.status == .need {
            grocery?.status = .dontNeed
        } else {
            grocery?.status = .need
        }
        delegate?.didChangeGroceryStatus(cell: self)
    }
    
}
