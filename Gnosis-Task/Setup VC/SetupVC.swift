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
    typealias Coordinator = SetupCoordinator
    
    @IBOutlet weak var textField: UITextField?
    
    private let viewModel = SetupViewModel()
    
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textField?.delegate = self
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

extension SetupVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.changedPrivateKey(text: textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        if text.isEmpty {
            print("Replacing characters called. Text: \(string)")
            viewModel.changedPrivateKey(text: string)
        }
        
        return true
    }
}
