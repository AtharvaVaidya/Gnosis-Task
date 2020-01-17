//
//  AccountVC.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {
    @IBOutlet weak var publicAddressLabel: UILabel!
    @IBOutlet weak var ethBalanceLabel: UILabel!
    
    let viewModel: AccountViewModel
    
    init?(coder: NSCoder, viewModel: AccountViewModel) {
        self.viewModel = viewModel
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bindToBalance(label: ethBalanceLabel)
        
        publicAddressLabel.text = viewModel.address
        ethBalanceLabel.text = viewModel.currentBalance
    }
    
    @IBAction func signMessagePressed(_ sender: Any) {
        
    }
    
    @IBAction func verifyPressed(_ sender: Any) {
        
    }
}
