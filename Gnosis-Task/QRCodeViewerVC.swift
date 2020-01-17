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
    }
    
    private func addSubviews() {
        view.addSubview(qrCodeView)
    }
    
    private func makeConstraints() {
        qrCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        let constraints = [qrCodeView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                           qrCodeView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
                           qrCodeView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
                           qrCodeView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)]
        
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
