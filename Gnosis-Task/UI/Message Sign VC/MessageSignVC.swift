//
//  MessageSignVC.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import web3swift

class MessageSignVC: UIViewController, Storyboarded {
    let viewModel: MessageSignViewModel
        
    var coordinator: MessageSignCoordinator?
    
    init?(coder: NSCoder, viewModel: MessageSignViewModel) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }

    @IBAction func changedText(_ sender: UITextField) {
        viewModel.change(message: sender.text ?? "")
    }
    
    @IBAction func signButtonPressed(_ sender: Any) {
        do {
            let signedMessage = try viewModel.signedMessage()
            coordinator?.showQRCode(data: signedMessage, message: viewModel.message)
        } catch {
            if let error = error as? Web3Error {
                switch error {
                case .connectionError:
                    print("Connection error")
                case .generalError(let generalError):
                    print("Error: \(generalError.localizedDescription)")
                case .keystoreError(let keystoreError):
                    print("Key store error: \(keystoreError.localizedDescription)")
                    switch keystoreError {
                    case .aesError:
                        print("AES Error")
                    case .encryptionError(let errorString):
                        print("Encryption Error: \(errorString)")
                    case .invalidAccountError:
                        print("Invalid account error")
                    case .keyDerivationError:
                        print("Key derivation error")
                    case .noEntropyError:
                        print("No entropy")
                    case .invalidPasswordError:
                        print("Invalid password")
                    }
                case .inputError(let description):
                    print("Error: \(description)")
                case .processingError(let description):
                    print("Error: \(description)")
                case .dataError:
                    print("Data error")
                case .nodeError(let description):
                    print("Error: \(description)")
                case .transactionSerializationError:
                    print("Transaction serialization error")
                case .unknownError:
                    print("Unknown error")
                case .walletError:
                    print("Wallet error")
                }
            }
        }
    }
}
