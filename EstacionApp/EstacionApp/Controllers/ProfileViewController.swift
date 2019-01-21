//
//  ProfileViewController.swift
//  EstacionApp
//
//  Created by Ernesto Daniel Mejia Valdiviezo on 1/21/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func closeSession(_ sender: UIButton) {
        let persistent = Persistent()
        
        persistent.deleteSession()
        
        navigationController?.popToViewController(self.navigationController?.viewControllers[0] as! InitialViewController, animated: true)
        
    }

}
