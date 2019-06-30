//
//  CategoryCell.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/31/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit

// MARK: Constants

let CategoryCellId = "CategoryCellId"
let CategoryCellHeight: CGFloat = 50.0

class CategoryCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var categoryNameLabel: RegularLabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    var category: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Layout
    
    func layoutForCategory(category: String, selected: Bool) {
        categoryNameLabel.text = category
        if selected {
            checkmarkImageView.isHidden = false
        } else {
            checkmarkImageView.isHidden = true
        }
    }
    
}

