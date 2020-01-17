//
//  QRCodeViewerVC.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import Combine

class QRCodeViewerVC: UIViewController {
    let qrCodeView = UIImageView()
    let messageLabel = UILabel()
    
    let viewModel: QRCodeViewerViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: QRCodeViewerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        addSubviews()
        makeConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        generateImage()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Signature"
        
        qrCodeView.contentMode = .scaleAspectFit
        
        messageLabel.text = "Message: \(viewModel.message)"
    }
    
    private func addSubviews() {
        view.addSubview(qrCodeView)
        view.addSubview(messageLabel)
    }
    
    private func makeConstraints() {
        qrCodeView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        let constraints = [qrCodeView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                           qrCodeView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
                           qrCodeView.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
                           qrCodeView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
                           qrCodeView.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 0.5),
                           messageLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20),
                           messageLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20),
                           messageLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 20)]
        
        NSLayoutConstraint.activate(constraints)
    }

    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func generateImage() {
        let referenceSize = qrCodeView.bounds.size
        
        let width = referenceSize.width * 0.75
        let height = referenceSize.height * 0.5
        
        let size = CGSize(width: width, height: height)
        
        viewModel.makeQRCodeImage(size: size)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showError(message: error.localizedDescription)
            case .finished: break
            }
        }) { [weak imageView = self.qrCodeView] (image) in
            imageView?.image = image
        }
        .store(in: &cancellables)
    }
}
