//
//  RegisterViewController.swift
//  EstacionApp
//
//  Created by Ernesto Daniel Mejia Valdiviezo on 1/2/19.
//  Copyright © 2019 Ernesto Daniel Mejia Valdiviezo. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

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
    }
    @IBAction func switchPlaceChanged(_ sender: UISwitch) {
        if thereIsAPlace.isOn{
            rate.isHidden = false
            address.isHidden = false
            parkingSwitch.isHidden = false
            parkingLabel.isHidden = false
            storeStuffSwitch.isHidden = false
            storeStuffLabel.isHidden = false
        }else{
            hidePlaceElements()
        }
    }
    func hidePlaceElements(){
        rate.isHidden = true
        address.isHidden = true
        parkingSwitch.isHidden = true
        parkingLabel.isHidden = true
        storeStuffSwitch.isHidden = true
        storeStuffLabel.isHidden = true
    }
    
}
