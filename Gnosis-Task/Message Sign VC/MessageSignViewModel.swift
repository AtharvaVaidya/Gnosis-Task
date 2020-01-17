//
//  MessageSignViewModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import web3swift

enum MessageSignError: Error {
    case noInternet
    
    var localizedDescription: String {
        switch self {
        case .noInternet: return "No Internet Connection"
        }
    }
}

class MessageSignViewModel {
    let model: MessageSignModel
    
    init(model: MessageSignModel) {
        self.model = model
    }
    
    func signedMessage() throws -> Data {
        guard let provider = InfuraProvider(.Rinkeby) else {
            throw MessageSignError.noInternet
        }
        
        let web3Obj = web3(provider: provider)
        
        let signedMessage = try web3Obj.wallet.signPersonalMessage(model.message, account: model.address)
        
        return signedMessage
    }
}
