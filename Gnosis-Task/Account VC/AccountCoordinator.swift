//
//  AccountCoordinator.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import web3swift

class AccountCoordinator: Coordinator {
    let address: EthereumAddress
    
    var navigationController: UINavigationController
    
    init(address: EthereumAddress, navigationController: UINavigationController) {
        self.address = address
        self.navigationController = navigationController
    }
    
    func start() {
        let model = AccountModel(address: address)
        let viewModel = AccountViewModel(model: model)
        
        let storyboard = UIStoryboard(name: "AccountVC", bundle: .main)
        
        guard let accountVC = storyboard.instantiateInitialViewController(creator: { (coder) -> AccountVC? in
            return AccountVC(coder: coder, viewModel: viewModel)
        }) else {
            return
        }
        
        accountVC.coordinator = self
        
        navigationController.pushViewController(accountVC, animated: true)
    }
    
    func signMessage() {
        let messageSignCoordinator = MessageSignCoordinator(address: address, navigationController: navigationController)
        messageSignCoordinator.start()
    }
}
