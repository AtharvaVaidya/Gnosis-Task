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
    
    let viewModel: QRCodeViewerViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: QRCodeViewerViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewModel.makeQRCodeImage(size: qrCodeView.bounds.size)
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
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
