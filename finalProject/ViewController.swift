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
import FirebaseDatabase
import FirebaseFirestore

class ViewController: UIViewController {
    
    //Mark: Outlets variables
    
    @IBOutlet weak var nameTextBox: UITextField!
    
    @IBOutlet var emailTextBox: UITextField!
    
    @IBOutlet var passwordTextBox: UITextField!
    
    @IBOutlet var statusLabel: UILabel!
    
    var db: Firestore!
    var ref: DocumentReference? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        db = Firestore.firestore()
    }
    
    //Mark: Outlet Actions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        // UI: Get the email/password from the text boxes
        let email = emailTextBox.text!
        let password = passwordTextBox.text!
        
        if (nameTextBox.text == "") {
            statusLabel.text = "Please enter your name"
        } else {
            
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

        ref = db.collection("users").addDocument(data: [
            "name": nameTextBox.text!,
            "money": 100,
            "email": emailTextBox.text!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
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
                self.performSegue(withIdentifier: "seguePick", sender: nil)

            }
            else {
                
                //  Show the error in user interface
                self.statusLabel.text = error?.localizedDescription
            }
        }
    }
    
    
     // MARK: - Navigation
     

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        let pickPokemonScreen = segue.destination as! PokemonSelectorController
        
        pickPokemonScreen.name = nameTextBox.text!
     }
    
}

