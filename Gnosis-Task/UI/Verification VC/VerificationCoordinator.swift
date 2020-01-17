//
//  VerificationCoordinator.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/18/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class VerificationCoordinator: Coordinator {
    let address: EthAddressInfo
    let navigationController: UINavigationController
    
    init(address: EthAddressInfo, navigationController: UINavigationController) {
        self.address = address
        self.navigationController = navigationController
    }
    
    func start() {
        let model = VerificationModel(address: address)
        let viewModel = VerificationViewModel(model: model)
        
        let viewController = VerificationVC(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
