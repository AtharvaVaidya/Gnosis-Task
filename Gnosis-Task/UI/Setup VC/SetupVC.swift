//
//  ViewController.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/13/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit
import web3swift
import Combine

final class SetupVC: UIViewController, Storyboarded {    
    @IBOutlet weak var textField: UITextField?
    
    private let viewModel = SetupViewModel()
    
    var coordinator: SetupCoordinator?

    @IBAction func privateKeyChanged(_ sender: Any) {
        viewModel.changedPrivateKey(text: textField?.text ?? "")
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        do {
            let address = try viewModel.generateAddress()
            coordinator?.goToAccountVC(address: address)
        } catch {
            showError(title: "Error", message: error.localizedDescription)
        }
    }
    
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController] (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
