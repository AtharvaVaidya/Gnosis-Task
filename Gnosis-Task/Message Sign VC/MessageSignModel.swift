//
//  MessageSignModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import web3swift

class MessageSignModel {
    @Published var message: String = ""
    let address: EthereumAddress
    
    init(address: EthereumAddress) {
        self.address = address
    }
}
