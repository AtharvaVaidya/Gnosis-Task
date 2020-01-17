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

class SetupVC: UIViewController {
    @IBOutlet weak var textField: UITextField?
    private let viewModel = SetupViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textField?.delegate = self
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        do {
            let address = try viewModel.generateAddress()
            goToAccountVC(address: address)
        } catch {
            showError(title: "Error", message: error.localizedDescription)
        }
    }
    
    func goToAccountVC(address: EthereumAddress) {
        let model = AccountModel(address: address)
        let viewModel = AccountViewModel(model: model)
        
        let storyboard = UIStoryboard(name: "AccountVC", bundle: .main)
        guard let accountVC = storyboard.instantiateInitialViewController(creator: { (coder) -> AccountVC? in
            return AccountVC(coder: coder, viewModel: viewModel)
        }) else {
            return
        }
        
        navigationController?.pushViewController(accountVC, animated: true)
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
        viewModel.changedPrivateKey(text: textField.text ?? "")
        return true
    }
}
