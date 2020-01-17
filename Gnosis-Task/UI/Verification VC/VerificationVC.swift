//
//  VerificationVC.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/18/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import AVFoundation

class VerificationVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let captureSession = AVCaptureSession()
    let videoLayer = AVCaptureVideoPreviewLayer()
    let qrCodeFrameView = UIView()
    
    let viewModel: VerificationViewModel
    
    init(viewModel: VerificationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCameraSession()
        setupQRCodeFrameView()
    }
    
    func setupQRCodeFrameView() {
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        
        view.addSubview(qrCodeFrameView)
        view.bringSubviewToFront(qrCodeFrameView)
    }
    
    func startCameraSession() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
         
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
         
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoLayer.session = captureSession
            videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoLayer)
            
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }
}

extension VerificationVC {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            qrCodeFrameView.frame = .zero
            return
        }
        
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            return
        }
                
        switch metadataObj.type {
        case .qr:
            if let qrCodeData = metadataObj.stringValue?.data(using: .utf8) {
                viewModel.foundQRCode(data: qrCodeData)
            }
            
            if let barCodeObject = videoLayer.transformedMetadataObject(for: metadataObj) {
                qrCodeFrameView.frame = barCodeObject.bounds
            }
        default:
            break
        }
    }
}
