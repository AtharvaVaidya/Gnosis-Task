//
//  AccountModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import web3swift

class AccountModel {
    let address: EthAddressInfo
    
    @Published var balance: String = "-"
    
    init(address: EthAddressInfo) {
        self.address = address
    }
}
