//
//  AccountViewModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import Combine
import web3swift
import BigInt

class AccountViewModel {
    enum BalanceFetchError: Error {
        case formattingError(BigUInt)
        case noInternet
    }
    
    let model: AccountModel
    
    var address: String {
        return model.address.ethereumAddress.address
    }
    
    var currentBalance: String {
        return model.balance
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: AccountModel) {
        self.model = model
        
        downloadBalance()
    }
    
    func bindToBalance(label: UILabel) {
        model.$balance
        .receive(on: RunLoop.main)
        .sink { [unowned label] (balance) in
            label.text = balance
        }
        .store(in: &cancellables)
    }
    
    private func downloadBalance() {
        generateAccountBalance(address: model.address)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            case .finished: break
            }
        }) { [weak model = self.model] (balance) in
            guard let model = model else {
                return
            }
            
            model.balance = balance
        }
        .store(in: &cancellables)
    }
    
    func generateAccountBalance(address: EthAddressInfo) -> Future<String, Error> {
        return Future<String, Error> { (promise) in
            let backgroundQueue = DispatchQueue.global(qos: .default)
            backgroundQueue.async {
                guard let provider = InfuraProvider(.Rinkeby) else {
                    promise(.failure(BalanceFetchError.noInternet))
                    return
                }
                
                let web3Object = web3(provider: provider)
                
                let eth = web3.Eth(provider: provider, web3: web3Object)
                
                do {
                    let balanceResult = try eth.getBalance(address: address.ethereumAddress)
                    guard let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 8) else {
                        promise(.failure(BalanceFetchError.formattingError(balanceResult)))
                        return
                    }
                    
                    promise(.success(balanceString))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
