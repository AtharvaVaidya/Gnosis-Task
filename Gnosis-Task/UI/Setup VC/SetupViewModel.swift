//
//  SetupVM.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/16/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import Combine
import web3swift
import BigInt

class SetupViewModel {
    enum PrivateKeyValidationError: Error {
        case badInputHex
        case unableToCreateKeystore
        case noValidAddressGenerated
        
        var localizedDescription: String {
            switch self {
            case .badInputHex:
                return "Private key is not valid."
            case .unableToCreateKeystore:
                return "Could not create keystore"
            case .noValidAddressGenerated:
                return "Could not generate a valid Ethereum Address from private key"
            }
        }
    }
    
    private let model = SetupModel()
    
    init() {
        
    }
    
    func changedPrivateKey(text: String) {
        model.privateKeyText = text
    }
    
    func generateAddress() throws -> EthAddressInfo {
        let privateKey = self.model.privateKeyText
        
        let password = "web3swift"
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let dataKey = Data.fromHex(formattedKey) else {
            throw PrivateKeyValidationError.badInputHex
        }
        
        guard let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password) else {
            throw PrivateKeyValidationError.unableToCreateKeystore
        }
        
        guard let address = keystore.addresses?.first?.address else {
            throw PrivateKeyValidationError.noValidAddressGenerated
        }
        
        guard let ethAddress = EthereumAddress(address) else {
            throw PrivateKeyValidationError.noValidAddressGenerated
        }
        
        return EthAddressInfo(privateKey: model.privateKeyText, ethereumAddress: ethAddress)
    }
}
