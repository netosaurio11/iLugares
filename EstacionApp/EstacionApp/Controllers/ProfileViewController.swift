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
        self.performSegue(withIdentifier: "unwindToViewController1", sender: self)
//        let rootVC: UIViewController?
//        
//        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialVC") as! InitialViewController
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        appDelegate.window?.rootViewController = rootVC
        
        //navigationController?.popToViewController(self.navigationController?.viewControllers[0] as! InitialViewController, animated: true)
        
    }

}
