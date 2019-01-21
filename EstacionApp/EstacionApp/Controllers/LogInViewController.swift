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
        
        navigationController?.isNavigationBarHidden = false
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
                                let useremail = document.data()["email"]
                                let userpassword = document.data()["password"]
                                
                                self.dataValid(useremail as! String, userpassword as! String)
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
    

    
    func dataValid(_ useremail: String, _ userpassword: String){
        if(useremail == email.text && userpassword == password.text){
            let session = (useremail, userpassword)
            performSegue(withIdentifier: "successLogin", sender: session)
        } else {
            self.present(errorAlert.missingFieldsAlert("Error", "Tus datos son incorrectosr"), animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! HomeViewController
        let (user, password) = sender as! (String, String)
        
        destination.saveSession(for: user, password)
    }

}
