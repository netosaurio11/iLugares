//
//  ProfileViewController.swift
//  EstacionApp
//
//  Created by Ernesto Daniel Mejia Valdiviezo on 1/21/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var constraintBottomScroll: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    ///Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    //Text fields
    @IBOutlet weak var newNameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    var user: User?
    let alert = Alert()
    var database = Database()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did load")
        
        database.readFromDatabase { (result: User) in
            self.user = result
            DispatchQueue.main.async {
                self.chargeLabels()
            }
        }

    }
    
    func chargeLabels() {
        nameLabel.text = user?.name
        lastnameLabel.text = user?.lastname
        emailLabel.text = user?.email
        phoneLabel.text = user?.phone
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
        
//        let selectedRange = scrollView.selectedRange
//        scrollView.scrollRangeToVisible(selectedRange)
    }
    
    
    
    @IBAction func closeSession(_ sender: UIButton) {
        let persistent = Persistent()
        
        persistent.deleteSession()
        self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
    }
    
    @IBAction func tapCloseKeyboard(_ sender: UITapGestureRecognizer) {
        
        //Terminar edición
        self.view.endEditing(true)
    }
    
    @IBAction func changeBtnPressed(_ sender: UIButton) {
        
        verifyTF(buttonPressed: sender.tag)
        
    }
    
    func verifyTF(buttonPressed: Int) {
        
        let persistent = Persistent()
        let (_, password) = persistent.readSession("username", "password")
        
        switch buttonPressed {
        case 0:
            //name
            if newNameTF.text != "" {
                let newName = newNameTF.text!
                update(field: "names", oldValue: nameLabel.text!, newValue: newName)
            } else {
                self.present(alert.missingFieldsAlert("Error", "Ingresa un nuevo nombre primero."), animated: true, completion: nil)
            }
            break
        case 1:
            //lastname
            if lastnameTF.text != "" {
                let newLastname = lastnameTF.text!
                update(field: "lastnames", oldValue: lastnameLabel.text!, newValue: newLastname)
            } else {
                self.present(alert.missingFieldsAlert("Error", "Ingresa un nuevo nombre primero."), animated: true, completion: nil)
            }
            break
        case 2:
            //phone
            if phoneTF.text != "" {
                let newPhone = phoneTF.text!
                update(field: "phone", oldValue: phoneLabel.text!, newValue: newPhone)
            } else {
                self.present(alert.missingFieldsAlert("Error", "Ingresa un nuevo nombre primero."), animated: true, completion: nil)
            }
            break
        case 3:
            //password
            if passwordTF.text != "" {
                let newPassword = passwordTF.text!
                update(field: "password", oldValue: password!, newValue: newPassword)
            } else {
                self.present(alert.missingFieldsAlert("Error", "Ingresa un nuevo nombre primero."), animated: true, completion: nil)
            }
            break
        default:
            break
            
        }
    }
    
    func update(field: String, oldValue: String, newValue: String) {
        
        
        database.updateInDatabase(field: field, from: oldValue, to: newValue) { (result: Bool) in
            
            if result {
                print("Base actualizada en el campo \(field).")
            } else {
                print("Error actualizando datos en base.")
            }
            self.present(self.alert.infoUpdate("Informacion actualizada", "Volveras a la pantalla anterior", self), animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }

}
