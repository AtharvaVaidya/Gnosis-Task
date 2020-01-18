//
//  MessageSignViewModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import web3swift
import CryptoSwift

enum MessageSignError: Error {
    case noInternet
    case dataEncodingError
    case signatureCreationError
    
    var localizedDescription: String {
        switch self {
        case .noInternet: return "No Internet Connection"
        case .dataEncodingError: return "Could not encode data"
        case .signatureCreationError: return "Could not sign the message."
        }
    }
}

class MessageSignViewModel {
    private let model: MessageSignModel
    
    init(model: MessageSignModel) {
        self.model = model
    }
    
    var message: String { model.message }
    
    func signedMessage() throws -> Data {
        guard let provider = InfuraProvider(.Rinkeby) else {
            throw MessageSignError.noInternet
        }
        
        guard let data = Data.fromHex(model.address.privateKey),
            let keystore = try EthereumKeystoreV3(privateKey: data) else {
            return Data()
        }
        
        let keystoreManager = KeystoreManager([keystore])

        let web3Obj = web3(provider: provider)
        web3Obj.addKeystoreManager(keystoreManager)
        
        let wallet = web3.Web3Wallet(provider: provider, web3: web3Obj)
                
        guard let messageData = model.message.data(using: .ascii) else {
            throw MessageSignError.dataEncodingError
        }
        
        let signedMessageData = try wallet.signPersonalMessage(messageData, account: model.address.ethereumAddress)
        let signedMessageHex = signedMessageData.toHexString()
        
        print("signed message hex string: \(signedMessageHex)")
        let signedQRCode = "\(signedMessageHex)/\(model.message)"
        let signedStringData = Data(signedQRCode.utf8)
        
        return signedStringData
    }
    
    func change(message: String) {
        model.message = message
    }
}
