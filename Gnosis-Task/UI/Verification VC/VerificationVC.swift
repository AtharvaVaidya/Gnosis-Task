//
//  VerificationVC.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/18/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import AVFoundation
import Combine

class VerificationVC: UIViewController {
    let captureSession = AVCaptureSession()
    let videoLayer = AVCaptureVideoPreviewLayer()
    let cameraView = UIView()
    
    let viewModel: VerificationViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: VerificationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "QR Code Scanner"
        
        addSubviews()
        makeConstraints()
        setupViews()
        
        startCameraSession()
        
        observeModel()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(cameraView)
    }
    
    private func makeConstraints() {
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        let constraints = [cameraView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                           cameraView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
                           cameraView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
                           cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func startCameraSession() {
        let backgroundQueue = DispatchQueue.global(qos: .userInteractive)
        backgroundQueue.async {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
             
            guard let captureDevice = deviceDiscoverySession.devices.first else {
                print("Failed to get the camera device")
                return
            }
             
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                self.captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                self.captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self.viewModel, queue: .global(qos: .default))
                captureMetadataOutput.metadataObjectTypes = [.qr]
                
                self.captureSession.startRunning()
                
                DispatchQueue.main.async {
                    self.videoLayer.session = self.captureSession
                    self.videoLayer.videoGravity = .resizeAspectFill
                    self.videoLayer.frame = self.cameraView.layer.bounds
                    self.cameraView.layer.addSublayer(self.videoLayer)
                }
            } catch {
                print(error)
            }
        }
    }
    
    //MARK:- Bindings
    private func observeModel() {
        viewModel.foundSignedMessage
        .dropFirst()
        .receive(on: RunLoop.main)
        .sink { isValidSignature in
            if isValidSignature {
                self.showAlert(title: "Signature is valid", message: "")
            } else {
                self.showAlert(title: "Invalid Signature", message: "")
            }
        }
        .store(in: &cancellables)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
