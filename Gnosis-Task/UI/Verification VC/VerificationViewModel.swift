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

class VerificationViewModel: NSObject {
    private let model: VerificationModel
        
    private var cancellables: Set<AnyCancellable> = []
        
    var foundSignedMessage: AnyPublisher<String, Never> {
        return
            model.$decodeMessage
            .compactMap({ $0 })
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
            let message = self.decode(data: data)
            self.model.decodeMessage = message
        }
        .store(in: &cancellables)
    }
    
    func foundQRCode(data: Data) {
        model.qrCodeData = data
    }
    
    func decode(data: Data) -> String {
        let message = String(data: data, encoding: .ascii)
        return message ?? ""
    }
}

extension VerificationViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
                
        
        if metadataObj.type == .qr {
            if let qrCodeData = metadataObj.stringValue?.data(using: .ascii) {
//                print("Got QR Code string: \(qrCodeString)")
               foundQRCode(data: qrCodeData)
            } else {
                print("Found metadataobject but couldn't decode.\n\(metadataObj)")
            }
        }
    }
}
