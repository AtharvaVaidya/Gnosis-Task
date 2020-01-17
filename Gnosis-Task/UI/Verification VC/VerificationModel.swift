//
//  VerificationModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/18/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation

class VerificationModel {
    @Published var qrCodeData: Data?
    
    private let address: EthAddressInfo
    
    init(address: EthAddressInfo) {
        self.address = address
    }
}
