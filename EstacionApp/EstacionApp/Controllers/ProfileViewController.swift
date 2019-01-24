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
    
    
    var user: User?

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
    
    
    

}
