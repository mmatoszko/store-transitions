//
//  AppDelegate.swift
//  StoreTransitions
//
//  Created by Mateusz Matoszko on 14/01/2019.
//  Copyright © 2019 Mateusz Matoszko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = ListViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        // Override point for customization after application launch.
        return true
    }

}

