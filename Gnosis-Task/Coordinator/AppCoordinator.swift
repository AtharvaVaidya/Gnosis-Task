//
//  AppCoordinator.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import Combine

class AppCoordinator: Coordinator {
    let window: UIWindow
    
    private var childCoordinators: [Coordinator] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func start() {
        let navigationController = UINavigationController()
        let myCoordinator = SetupCoordinator(navigationController: navigationController)

        self.store(coordinator: myCoordinator)
        myCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        myCoordinator.isComplete
        .receive(on: RunLoop.main)
        .sink { [unowned self] (completed) in
            if completed {
                self.free(coordinator: myCoordinator)
            }
        }
        .store(in: &cancellables)
    }
}
