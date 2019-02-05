//
//  Database.swift
//  EstacionApp
//
//  Created by Josue Quiñones on 1/24/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import Foundation
import Firebase

struct Database {
    
    var db: Firestore!
    
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    func readFromDatabase(onSuccess: @escaping (User) -> Void) {
        
        let persistent = Persistent()
        let (user, _) = persistent.readSession("username", "password")
        let usersRef = db.collection("users")
        var userReturn = User(name: "", lastname: "", email: "", phone: "", password: "", rate: "0", address: "", parking: false, storestuff: false)
        
        if let userEmail = user {
            usersRef.whereField("email", isEqualTo: userEmail)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print(document)
                            let name = document.data()["names"]
                            let lastname = document.data()["lastnames"]
                            let email = document.data()["email"]
                            let phone = document.data()["phone"]
                            let password = document.data()["password"]
                            
                            userReturn.name = name as! String
                            userReturn.lastname = lastname as! String
                            userReturn.email = email as! String
                            userReturn.phone = phone as! String
                            userReturn.password = password as! String
                            print(userReturn.name)
                            onSuccess(userReturn)
                        }
                    }
            }
        }
    }
    
    func updateInDatabase(field: String, from oldValue: String, to newValue: String, onSuccess: @escaping (Bool)-> Void) {
        
        var status = false
        
        let persistent = Persistent()
        let (user, _) = persistent.readSession("username", "password")
        
        //Actualizar keyChain
        if field == "password" {
            if persistent.saveSession(user!, newValue) {
                print("Password actualizado en Keychain")
            } else {
                print("Error actualizando password en Keychain")
            }
        }
        
        //Actualizar en Base de datos
        let usersRef = db.collection("users")
        
        if let userEmail = user {
            usersRef.whereField("email", isEqualTo: userEmail)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        status = false
                    } else {
                        for document in querySnapshot!.documents {
                            usersRef.document(document.documentID).updateData([
                            field: newValue
                            ]){ err in
                                if let err = err {
                                    print("Error updating document, reason: \(err)")
                                    status = false
                                } else {
                                    print("Document successfully updated")
                                    status = true
                                }
                            }
                        }
                    }
            }
        }
        onSuccess(status)
    }
    
}
