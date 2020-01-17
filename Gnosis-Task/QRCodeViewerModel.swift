//
//  QRCodeViewerModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

class QRCodeViewerModel {
    var data: Data
    
    init(qrCodeData: Data) {
        self.data = qrCodeData
    }
}
