//
//  VerificationViewModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/18/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

class VerificationViewModel {
    let model: VerificationModel
        
    var cancellables: Set<AnyCancellable> = []
    
    init(model: VerificationModel) {
        self.model = model
    }
    
    func observeData() {
        model.$qrCodeData
        .receive(on: DispatchQueue.global(qos: .default))
        .compactMap { $0 }
        .sink { (data) in
            
        }
        .store(in: &cancellables)
    }
    
    func foundQRCode(data: Data) {
        model.qrCodeData = data
    }
    
    func checkIfSignatureIsValid(data: Data) {
        
    }
}
