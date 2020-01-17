//
//  MainCoordinator.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import Combine
import web3swift

class SetupCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let isCompletedPublisher = PassthroughSubject<Bool, Never>()
    
    var isComplete: AnyPublisher<Bool, Never> {
        return isCompletedPublisher.prefix(1).eraseToAnyPublisher()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let setupVC = SetupVC.instantiate()
        setupVC.coordinator = self
        navigationController.pushViewController(setupVC, animated: true)
    }
    
    func goToAccountVC(address: EthereumAddress) {
        let accountCoordinator = AccountCoordinator(address: address, navigationController: navigationController)
        accountCoordinator.start()
    }
}
