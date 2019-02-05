//
//  RegisterViewController.swift
//  EstacionApp
//
//  Created by Ernesto Daniel Mejia Valdiviezo on 1/2/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit
import Firebase
import MapKit

protocol HandleResultsSearch {
    func dropValueOf(placemark:MKPlacemark)
}

class RegisterViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate, HandleResultsSearch {
    var user: User = User(name: "", lastname: "", email: "", phone: "", password: "", rate: "0", address: "", parking: false, storestuff: false)
    var db: Firestore!
    let alert = Alert()
    var success: Bool = false

    
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
    @IBOutlet weak var addAddress: UIButton!
    //Scroll view
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidePlaceElements()
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Observers para el teclado
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    

    @IBAction func switchPlaceChanged(_ sender: UISwitch) {
        if thereIsAPlace.isOn{
            showPlaceElements()
        }else{
            hidePlaceElements()
        }
    }
    @IBAction func registerTapped(_ sender: UIButton!) {
        let switchOn = thereIsAPlace.isOn
        switch switchOn {
        case true:
            specialRegister()
        case false:
            normalRegister()

        }
        if success {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func specialRegister() {
        if (names.text == "" || lastnames.text == "" || email.text == "" || phone.text == "" || password.text == "" || rate.text == "" || address.text == "" || (storeStuffSwitch.isOn == false && parkingSwitch.isOn == false)){
            self.present(alert.missingFieldsAlert("Error", "Debes llenar todos los campos solcitados."), animated: true, completion: nil)
        } else {
            if password.text != password2.text{
                self.present(alert.passwordErrorAlert("Error", "Tus contraseñas deben coincidir."), animated: true, completion: nil)
            } else {
                RegisterSpecialUser()
            }
        }
    }
    
    func normalRegister(){
        if (names.text == "" || lastnames.text == "" || email.text == "" || phone.text == "" || password.text == ""){
            self.present(alert.missingFieldsAlert("Error", "Debes llenar todos los campos solcitados."), animated: true, completion: nil)
        } else {
            if password.text != password2.text{
                self.present(alert.passwordErrorAlert("Error", "Tus contraseñas deben coincidir."), animated: true, completion: nil)
            } else {
                RegisterNormalUser()
            }
        }
    }
    func createNormalUser() -> User {
        if checkTextFields(names, lastnames, email, phone, password){
            user.name = names.text!
            user.lastname = lastnames.text!
            user.email = email.text!
            user.phone = phone.text!
            user.password = password.text!
        }
        return user
    }
    
    func createSpecialUser() -> User {
        if checkTextFields(names, lastnames, email, phone, password, rate, address){
            user.name = names.text!
            user.lastname = lastnames.text!
            user.email = email.text!
            user.phone = phone.text!
            user.password = password.text!
            user.rate = rate.text!
            user.address = address.text!
            user.storestuff = storeStuffSwitch.isOn
            user.parking = parkingSwitch.isOn
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
        addAddress.isHidden = false
    }
    func hidePlaceElements(){
        rate.isHidden = true
        address.isHidden = true
        parkingSwitch.isHidden = true
        parkingLabel.isHidden = true
        storeStuffSwitch.isHidden = true
        storeStuffLabel.isHidden = true
        addAddress.isHidden = true
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
    func RegisterNormalUser() {
        let userToRegister = createNormalUser()
        var ref: DocumentReference? = nil
        // Add a second document with a generated ID.
        ref = db.collection("users").addDocument(data: [
            "names": userToRegister.name,
            "lastnames": userToRegister.lastname,
            "email": userToRegister.email,
            "phone": userToRegister.phone,
            "password": userToRegister.password
        ]) { [unowned self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.present(self.alert.correctRegister("Usuario Registrado", "Has sido registrado correctamente", action: self.alert.createActionWithHandler(for: self)), animated: true, completion: nil)
                self.clearTextFields()
                self.hidePlaceElements()
                self.success = true
            }
        }
    }
    func RegisterSpecialUser() {
        let userToRegister = createSpecialUser()
        var ref: DocumentReference? = nil
        // Add a second document with a generated ID.
        ref = db.collection("users").addDocument(data: [
            "names": userToRegister.name,
            "lastnames": userToRegister.lastname,
            "email": userToRegister.email,
            "phone": userToRegister.phone,
            "rate": userToRegister.rate,
            "address": userToRegister.address,
            "storestuff": userToRegister.storestuff,
            "parking": userToRegister.parking,
            "password:": userToRegister.password
        ]) { [unowned self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.present(self.alert.correctRegister("Usuario Registrado", "Has sido registrado correctamente", action: self.alert.createActionWithHandler(for: self)), animated: true, completion: nil)
                self.clearTextFields()
                self.hidePlaceElements()
                self.success = true
            }
        }
    }
    func checkTextFields(_ texfields: UITextField...) -> Bool {
        for textfield in texfields {
            if textfield.text == nil {
                self.present(alert.missingFieldsAlert("Error", "Debes llenar todos los campos."), animated: true, completion: nil)
                return false
            } else {
                return true
            }
        }
        
        return true
    }
    
    @IBAction func addAddressTapped(_ sender: UIButton) {
        address.isEnabled = true
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "RegisterLocationSearchTable") as! RegisterLocationSearchTable
        
        let searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController.searchResultsUpdater = locationSearchTable
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for places"
        definesPresentationContext = true
        locationSearchTable.handleResultsSearchDelegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func dropValueOf(placemark: MKPlacemark) {
        address.text = placemark.title
    }
    
    
    @IBAction func closeKeyboarkTap(_ sender: UITapGestureRecognizer) {
        //Terminar edición
        self.view.endEditing(true)
    }
    
}
