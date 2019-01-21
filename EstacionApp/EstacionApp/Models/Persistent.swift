//
//  Persistent.swift
//  EstacionApp
//
//  Created by Josue Quiñones on 1/20/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import Foundation

struct Persistent {
    
    func saveSession(_ username: String, _ password: String) -> Bool {
        
        let saveUser: Bool = KeychainWrapper.standard.set(username, forKey: "username")
        let savePassword: Bool = KeychainWrapper.standard.set(password, forKey: "password")
        
        if saveUser && savePassword {
            return true
        } else {
            return false
        }
        
    }
    
    func readSession(_ username: String, _ password: String) -> (String?, String?) {
        let userSaved : String? = KeychainWrapper.standard.string(forKey: username)
        let passwordSaved : String? = KeychainWrapper.standard.string(forKey: password)
        
        if let user = userSaved, let password = passwordSaved {
            return (user,password)
        } else {
            return (nil,nil)
        }
    }
    
    func deleteSession() {
        let removeUser = KeychainWrapper.standard.removeAllKeys()
        
        if removeUser {
            print("Keychain vacio")
        } else {
            print("Error eliminando sesión")
        }
    }
    
    
}
