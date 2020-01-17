//
//  MainCoordinator.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import web3swift

class SetupCoordinator: Coordinator {    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let setupVC = SetupVC.instantiate()
        setupVC.coordinator = self
        navigationController.pushViewController(setupVC, animated: true)
    }
    
    func goToAccountVC(address: EthAddressInfo) {
        let accountCoordinator = AccountCoordinator(address: address, navigationController: navigationController)
        accountCoordinator.start()
    }
}
