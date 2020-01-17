//
//  Address.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/18/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import web3swift

class EthAddressInfo {
    let privateKey: String
    let ethereumAddress: EthereumAddress
    
    init(privateKey: String, ethereumAddress: EthereumAddress) {
        self.privateKey = privateKey
        self.ethereumAddress = ethereumAddress
    }
}
