//
//  AppCoordinator.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow
            
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        
        let myCoordinator = SetupCoordinator(navigationController: navigationController)
        
        myCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
