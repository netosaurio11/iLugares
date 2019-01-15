//
//  LogInViewController.swift
//  EstacionApp
//
//  Created by Ernesto Daniel Mejia Valdiviezo on 1/2/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var db: Firestore!
    let errorAlert =  Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    @IBAction func logIn(_ sender: UIButton) {
         let usersRef = db.collection("users")
        if verifyTextFields() {
            if let userEmail = email.text{
                usersRef.whereField("email", isEqualTo: userEmail)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                            }
                        }
                }
            }
        }
        
    }
    
    func verifyTextFields() -> Bool {
        if email.text == "" && password.text != "" {
            self.present(errorAlert.missingEmail("Error", "Favor de ingresar un correo válido."), animated: true, completion: nil)
            return false
        }
        if password.text == "" && email.text != "" {
            self.present(errorAlert.passwordErrorAlert("Error", "Debes ingresar una contraseña válida."), animated: true, completion: nil)
            return false
        }
        if email.text == "" && password.text == "" {
            self.present(errorAlert.missingFieldsAlert("Error", "Debes llenar ambos campos."), animated: true, completion: nil)
        }
        return true
    }

}
