//
//  HomeViewController.swift
//  EstacionApp
//
//  Created by Josue Quiñones on 1/19/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func saveSession(for user: String, _ password: String) {
        let persistent = Persistent()
        if persistent.saveSession(user, password) {
            print("Session saved with success")
        } else {
            print("Error saving session")
        }
    }
    
    
    @IBAction func closeSession(_ sender: UIButton) {
        let persistent = Persistent()
        
        persistent.deleteSession()
        
    navigationController?.popToViewController(self.navigationController?.viewControllers[0] as! InitialViewController, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
