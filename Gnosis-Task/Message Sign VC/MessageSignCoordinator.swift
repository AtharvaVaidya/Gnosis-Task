//
//  MessageSignCoordinator.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import web3swift

class MessageSignCoordinator: Coordinator {
    let address: EthereumAddress
    let navigationController: UINavigationController
    
    init(address: EthereumAddress, navigationController: UINavigationController) {
        self.address = address
        self.navigationController = navigationController
    }
    
    func start() {
        let model = MessageSignModel(address: address)
        let viewModel = MessageSignViewModel(model: model)
        
        let storyboard = MessageSignVC.storyboard()
        
        guard let messageSignVC = storyboard.instantiateInitialViewController(creator: { (coder) -> MessageSignVC? in
            return MessageSignVC(coder: coder, viewModel: viewModel)
        }) else {
            return
        }
        
        messageSignVC.coordinator = self
        
        navigationController.pushViewController(messageSignVC, animated: true)
    }
    
    func showQRCode(data: Data) {
        let qrCodeViewerCoordinator = QRCodeViewerCoordinator(qrCodeData: data, navigationController: navigationController)
        qrCodeViewerCoordinator.start()
    }
}
