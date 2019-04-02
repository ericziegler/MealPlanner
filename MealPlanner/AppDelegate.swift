//
//  AppDelegate.swift
//  MealPlanner
//
//  Created by Eric Ziegler on 3/16/19.
//  Copyright © 2019 zigabytes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        applyApplicationAppearanceProperties()
        
        // TODO: EZ - Comment out this code. It's for testing only
        //MealPlannerTests.shared.runTests()
        
        return true
    }

}

