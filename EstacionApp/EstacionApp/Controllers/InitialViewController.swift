//
//  InitialViewController.swift
//  EstacionApp
//
//  Created by Josue Quiñones on 1/20/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [START setup]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        verifySession()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    func verifySession() {
        let persistent = Persistent()
        
        let (user, password) = persistent.readSession("username", "password")
        let usersRef = db.collection("users")
        
        if let userEmail = user, let userPassword = password {
            usersRef.whereField("email", isEqualTo: userEmail)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let useremail = document.data()["email"]
                            let userpassword = document.data()["password"]
                            
                            if userEmail == useremail as! String && userPassword == userpassword as! String {
                                self.performSegue(withIdentifier: "SessionSavedSegue", sender: nil)
                            }
                        }
                    }
            }
        }
        
    }
    

}
