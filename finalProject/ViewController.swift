//
//  ViewController.swift
//  finalProject
//
//  Created by Mike Banks and Salim Elewa on 2018-12-06.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire


class ViewController: UIViewController {
    
    //Mark: Outlets variables
    @IBOutlet var emailTextBox: UITextField!
    
    @IBOutlet var passwordTextBox: UITextField!
    
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //Mark: Outlet Actions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        // UI: Get the email/password from the text boxes
        let email = emailTextBox.text!
        let password = passwordTextBox.text!
        
        // MARK: FB:  Try to create a user using Firebase Authentication
        // This is all boilerplate code copied and pasted from Firebase documentation
        Auth.auth().createUser(withEmail: email, password: password) {
            
            (user, error) in
            
            if (user != nil) {
                self.statusLabel.text = "You have created a login"
            }
            else {
                self.statusLabel.text = error?.localizedDescription 
            }
        }
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        // UI: Get the email/password from the text boxes
        let email = emailTextBox.text!
        let password = passwordTextBox.text!
        
        // MARK: FB:  Try to sign the user in using Firebase Authentication
        // This is all boilerplate code copied and pasted from Firebase documentation
        Auth.auth().signIn(withEmail: email, password: password) {
            
            (user, error) in
            
            if (user != nil) {
                self.statusLabel.text = "You are in the system"
                self.performSegue(withIdentifier: "segueOne", sender: nil)

            }
            else {
                
                //  Show the error in user interface
                self.statusLabel.text = error?.localizedDescription
            }
        }
    }
    

}

