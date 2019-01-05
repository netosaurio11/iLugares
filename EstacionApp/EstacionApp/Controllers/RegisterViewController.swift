//
//  RegisterViewController.swift
//  EstacionApp
//
//  Created by Ernesto Daniel Mejia Valdiviezo on 1/2/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    var user: User = User(name: "", lastname: "", email: "", phone: "", password: "", rate: 0.0, address: "", parking: false, storestuff: false)
    var db: Firestore!
    
    //Basic Info
    @IBOutlet weak var names: UITextField!
    @IBOutlet weak var lastnames: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    
    //Extra Info
    @IBOutlet weak var thereIsAPlace: UISwitch!
    @IBOutlet weak var rate: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var parkingSwitch: UISwitch!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var storeStuffSwitch: UISwitch!
    @IBOutlet weak var storeStuffLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidePlaceElements()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    @IBAction func switchPlaceChanged(_ sender: UISwitch) {
        if thereIsAPlace.isOn{
            showPlaceElements()
        }else{
            hidePlaceElements()
        }
    }
    @IBAction func registerTapped(_ sender: UIButton) {
        if createUser() {
            var ref: DocumentReference? = nil
            // Add a second document with a generated ID.
            ref = db.collection("users").addDocument(data: [
                "names": user.name,
                "lastnames": user.lastname,
                "email": user.email,
                "phone": user.phone
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    let alertRegister = UIAlertController(title: "Usuario Registrado", message: "Has sido registrado correctamente", preferredStyle: .actionSheet)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertRegister.addAction(okAction)
                    self.present(alertRegister, animated: true, completion: nil)
                    self.clearTextFields()
                }
            }

        }
    }
    func createUser() -> Bool {
        let alert = UIAlertController(title: "Error", message: "Debes llenar todos los campos.", preferredStyle: .actionSheet)
        let alertPassword = UIAlertController(title: "Error", message: "Tus contraseñas deben coincidir", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertPassword.addAction(okAction)
        alert.addAction(okAction)
        guard let username = names.text else {
            self.present(alert, animated: true, completion: nil)
            return false
        }
        guard let userlastname = lastnames.text else {
            self.present(alert, animated: true, completion: nil)
            return false
        }
        guard let useremail = email.text else {
            self.present(alert, animated: true, completion: nil)
            return false
        }
        guard let userphone = phone.text else {
            self.present(alert, animated: true, completion: nil)
            return false
        }
        guard let userpassword = password.text else {
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if userpassword != password2.text {
            self.present(alertPassword, animated: true, completion: nil)
            return false
        }
        
        user.name = username
        user.lastname = userlastname
        user.email = useremail
        user.phone = userphone
        user.password = userpassword
        
        return true
    }
    
    func showPlaceElements(){
        rate.isHidden = false
        address.isHidden = false
        parkingSwitch.isHidden = false
        parkingLabel.isHidden = false
        storeStuffSwitch.isHidden = false
        storeStuffLabel.isHidden = false
    }
    func hidePlaceElements(){
        rate.isHidden = true
        address.isHidden = true
        parkingSwitch.isHidden = true
        parkingLabel.isHidden = true
        storeStuffSwitch.isHidden = true
        storeStuffLabel.isHidden = true
    }
    func clearTextFields(){
        names.text = ""
        lastnames.text = ""
        email.text = ""
        phone.text = ""
        password.text = ""
        password2.text = ""
        rate.text = ""
        address.text = ""
    }
    
}
