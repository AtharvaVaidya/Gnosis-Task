//
//  AppDelegate.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/13/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        
        self.appCoordinator = appCoordinator
        
        return true
    }
}

