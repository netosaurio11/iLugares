//
//  RegisterViewController.swift
//  EstacionApp
//
//  Created by Ernesto Daniel Mejia Valdiviezo on 1/2/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    var user: User = User(name: "", lastname: "", email: "", phone: "", password: "", rate: 0.0, address: "", parking: false, storestuff: false)
    var db: Firestore!
    let alert = Alert()

    
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
    @IBAction func registerTapped(_ sender: UIButton!) {
        if (names.text == "" || lastnames.text == "" || email.text == "" || phone.text == "" || password.text == ""){
            self.present(alert.missingFieldsAlert("Error", "Debes llenar todos los campos solcitados."), animated: true, completion: nil)
        } else {
            if password.text != password2.text{
                self.present(alert.passwordErrorAlert("Error", "Tus contraseñas deben coincidir."), animated: true, completion: nil)
            } else {
                connectToFireBase()
            }
        }
    }
    func createUser() -> User {
        if let username = names.text,let userlastname = lastnames.text,let useremail = email.text, let userphone = phone.text, let userpassword = password.text{
                user.name = username
                user.lastname = userlastname
                user.email = useremail
                user.phone = userphone
                user.password = userpassword
        } else{
            self.present(alert.missingFieldsAlert("Error", "Debes llenar todos los campos."), animated: true, completion: nil)
        }
        return user
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            registerTapped(nil)
        }
        
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
    func connectToFireBase () {
        let userToRegister = createUser()
        var ref: DocumentReference? = nil
        // Add a second document with a generated ID.
        ref = db.collection("users").addDocument(data: [
            "names": userToRegister.name,
            "lastnames": userToRegister.lastname,
            "email": userToRegister.email,
            "phone": userToRegister.phone
        ]) { [unowned self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.present(self.alert.correctRegister("Usuario Registrado", "Has sido registrado correctamente"), animated: true, completion: nil)
                self.clearTextFields()
            }
        }
    }
}
