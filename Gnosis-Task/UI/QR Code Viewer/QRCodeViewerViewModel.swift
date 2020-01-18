//
//  QRCodeViewerViewModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import Combine

class QRCodeViewerViewModel {
    let model: QRCodeViewerModel
    
    init(model: QRCodeViewerModel) {
        self.model = model
    }
    
    var message: String { model.message }
    
    func makeQRCodeImage(size: CGSize) -> Future<UIImage, QRCodeGenerationError> {        
        return QRCodeGenerator.generateImage(with: model.data, size: size)
    }
}
