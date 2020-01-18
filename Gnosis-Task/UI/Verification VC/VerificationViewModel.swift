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
import web3swift

class VerificationViewModel: NSObject {
    private let model: VerificationModel
        
    private var cancellables: Set<AnyCancellable> = []
        
    var foundSignedMessage: AnyPublisher<Bool, Never> {
        return
            model.$signatureIsValid
            .eraseToAnyPublisher()
    }
    
    init(model: VerificationModel) {
        self.model = model
        
        super.init()
        
        observeData()
    }
    
    private func observeData() {
        model.$qrCodeData
        .receive(on: DispatchQueue.global(qos: .default))
        .compactMap { $0 }
        .sink { [unowned self] (data) in
            self.model.signatureIsValid = self.isSignatureValid(data: data)
        }
        .store(in: &cancellables)
    }
    
    func foundQRCode(data: Data?) {
        if model.qrCodeData == data {
            return
        }
        
        model.qrCodeData = data
    }
    
    func isSignatureValid(data: Data) -> Bool {
        guard let qrCode = String(data: data, encoding: .utf8) else {
            return false
        }
        
        guard let indexOfSeparator = qrCode.firstIndex(of: "/") else {
            return false
        }
        
        let signedHexString = String(qrCode[qrCode.startIndex..<indexOfSeparator])
        let startIndexOfPersonalMessage = qrCode.index(after: indexOfSeparator)
        
        let personalMessage = String(qrCode[startIndexOfPersonalMessage..<qrCode.endIndex])
        
        let signature = Data(hex: signedHexString)
        
        let web3 = Web3.InfuraRinkebyWeb3()
        
        let personalMessageData = Data(personalMessage.utf8)
        
        do {
            let signer = try web3.personal.ecrecover(personalMessage: personalMessageData, signature: signature)
            return signer == model.address.ethereumAddress
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return false
    }
}

extension VerificationViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            foundQRCode(data: nil)
            return
        }
                
        
        if metadataObj.type == .qr {
            if let qrCodeData = metadataObj.stringValue?.data(using: .utf8) {
               foundQRCode(data: qrCodeData)
            } else {
                foundQRCode(data: nil)
            }
        }
    }
}
