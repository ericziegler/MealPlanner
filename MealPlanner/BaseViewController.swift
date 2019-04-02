//
//  BaseViewController.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/22/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = navTitleTextAttributes()
    }
    
}
