//
//  QRCodeViewerViewModel.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import Combine

class QRCodeViewerViewModel {
    let model: QRCodeViewerModel
    
    init(model: QRCodeViewerModel) {
        self.model = model
    }
    
    var message: String { model.message }
    
    func makeQRCodeImage(size: CGSize) -> Future<UIImage, QRCodeGenerationError> {
        return Future<UIImage, QRCodeGenerationError> { [weak model = self.model] promise in
            guard let model = model else {
                promise(.failure(.unableToCreateImage))
                return
            }
            
            let backgroundQueue = DispatchQueue.global(qos: .userInteractive)
            
            backgroundQueue.async {
                let filter = CIFilter.qrCodeGenerator
                
                filter.setValue(model.data, forKey: CIFilterAtrributes.inputMessage.rawValue)
                filter.setValue(CIFilterInputCorrectionValues.h.rawValue, forKey: CIFilterAtrributes.inputCorrectionLevel.rawValue)
                
                guard let outputImage = filter.outputImage else {
                    promise(.failure(.unableToCreateImage))
                    return
                }
                
                let minimalSideLength = outputImage.extent.width
                
                let smallestOutputExtent = (size.width < size.height) ? size.width : size.height
                
                let scaleFactor = smallestOutputExtent / minimalSideLength
                
                let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                let scaledImage = outputImage.transformed(by: scaleTransform)
                
                let image = UIImage(ciImage: scaledImage, scale: UIScreen.main.scale, orientation: .up)
                
                promise(.success(image))
            }
        }
    }
}

enum QRCodeGenerationError: Error {
    case unableToCreateImage
    
    var localizedDescription: String {
        switch self {
        case .unableToCreateImage:
            return "Unable to create image from data"
        }
    }
}

fileprivate extension CIFilter {
    enum CIFilterName: String {
        case qrCodeGenerator = "CIQRCodeGenerator"
    }
    
    static var qrCodeGenerator: CIFilter {
        let filter = CIFilter(name: CIFilterName.qrCodeGenerator.rawValue) ?? CIFilter()
        
        return filter
    }
}

fileprivate enum CIFilterAtrributes: String {
    case inputMessage
    case inputCorrectionLevel
}

fileprivate enum CIFilterInputCorrectionValues: String {
    case h = "H"
}
