//
//  Alert.swift
//  EstacionApp
//
//  Created by Ernesto Daniel Mejia Valdiviezo on 1/11/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import Foundation
import UIKit

struct Alert{
    
   
    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
    func correctRegister(_ title: String, _ message: String, action: UIAlertAction) -> UIAlertController {
        let alertRegister = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertRegister.addAction(action)
        return alertRegister
    }
    
    func missingFieldsAlert(_ title: String, _ message: String) -> UIAlertController {
        let alertError = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertError.addAction(okAction)
        return alertError
    }
    func passwordErrorAlert(_ title: String, _ message: String) -> UIAlertController {
         let alertPassword = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertPassword.addAction(okAction)
        return alertPassword
    }
    func missingEmail(_ title: String, _ message: String) -> UIAlertController {
        let alertEmail = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertEmail.addAction(okAction)
        return alertEmail
    }
    
    func createActionWithHandler(for controller: UIViewController) -> UIAlertAction {
        return UIAlertAction(title: "Ok", style: .cancel) { [unowned controller] action in
            controller.navigationController?.popViewController(animated: true)
        }
    }
}
