//
//  VerificationModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/18/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import Combine

class VerificationModel {
    @Published var qrCodeData: Data?
    
    let address: EthAddressInfo
    
    @Published var signatureIsValid: Bool = false
    
    init(address: EthAddressInfo) {
        self.address = address
    }
}
