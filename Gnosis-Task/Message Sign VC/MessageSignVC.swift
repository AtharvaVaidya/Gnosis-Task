//
//  MessageSignVC.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class MessageSignVC: UIViewController, Storyboarded {
    let viewModel: MessageSignViewModel
    
    @IBOutlet weak var textfield: UITextField!
    
    var coordinator: MessageSignCoordinator?
    
    init?(coder: NSCoder, viewModel: MessageSignViewModel) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    @IBAction func signButtonPressed(_ sender: Any) {
        do {
            let signedMessage = try viewModel.signedMessage()
            coordinator?.
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
