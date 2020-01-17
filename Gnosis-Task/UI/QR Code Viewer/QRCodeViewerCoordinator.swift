//
//  QRCodeViewerCoordinator.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class QRCodeViewerCoordinator: Coordinator {
    let data: Data
    let message: String
    let navigationController: UINavigationController
    
    init(qrCodeData: Data, message: String, navigationController: UINavigationController) {
        self.data = qrCodeData
        self.message = message
        self.navigationController = navigationController
    }
    
    func start() {
        let model = QRCodeViewerModel(qrCodeData: data, message: message)
        let viewModel = QRCodeViewerViewModel(model: model)
        let viewController = QRCodeViewerVC(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
