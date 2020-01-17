//
//  QRCodeViewerModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

class QRCodeViewerModel {
    let data: Data
    let message: String
    
    init(qrCodeData: Data, message: String) {
        self.data = qrCodeData
        self.message = message
    }
}
