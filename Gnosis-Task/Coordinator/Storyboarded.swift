//
//  Storyboarded.swift
//  Gnosis-Task
//
//  Created by Atharva Vaidya on 1/17/20.
//  Copyright © 2020 Atharva Vaidya. All rights reserved.
//

import UIKit

protocol Storyboarded {
    associatedtype Coordinator
    
    var coordinator: Coordinator? { get set }
    
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)

        let className = fullName.components(separatedBy: ".")[1]
        
        let storyboard = UIStoryboard(name: className, bundle: .main)
        
        guard let controller = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Could not initialize view controller from storyboard")
        }
        
        return controller
    }
}
