//
//  BattleViewController.swift
//  finalProject
//
//  Created by Salim Elewa on 2018-12-07.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class BattleViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var enemyNameLabel: UILabel!
    @IBOutlet weak var enemyStatsLabel: UILabel!
    @IBOutlet weak var enemyImage: UIImageView!
    @IBOutlet weak var enemyHealthLabel: UILabel!
    
    @IBOutlet weak var gameMessageLabel: UILabel!
    
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var yourStatsLabel: UILabel!
    @IBOutlet weak var yourImage: UIImageView!
    @IBOutlet weak var yourHealthLabel: UILabel!
    
    @IBOutlet weak var punchButton: UIButton!
    @IBOutlet weak var kickButton: UIButton!
    @IBOutlet weak var upperCutButton: UIButton!
    @IBOutlet weak var goatSlapButton: UIButton!
    @IBOutlet weak var surrenderButton: UIButton!
    
    //MARK: - Variables
    var myPokemon:Pokemon!
    var enemyPokemon:Pokemon!
    var imageData:Data!
    var layer1 = CALayer()
    
    var numWins:Int!
    var userMoney:Int!
    var documentID:String!
    var db:Firestore!

        
    //MARK: - Default Functiom
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()

        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        enemyNameLabel.text = enemyPokemon.pokemonName
        enemyStatsLabel.text = "ATT: \(enemyPokemon.pokemonAttack)  DEF: \(enemyPokemon.pokemonDefense)"
        enemyHealthLabel.text = "HP: \(enemyPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        do {
            imageData = try Data(contentsOf: self.enemyPokemon.pokemonImage!)
            enemyImage.image = UIImage(data: imageData)
        } catch {
            print("error with enemy image")
        }
        
        gameMessageLabel.text = "YOUR MOVE FIRST"
        
        yourNameLabel.text = myPokemon.pokemonName
        yourStatsLabel.text = "ATT: \(myPokemon.pokemonAttack)  DEF: \(myPokemon.pokemonDefense)"
        yourHealthLabel.text = "HP: \(myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        do {
            imageData = try Data(contentsOf: self.myPokemon.pokemonImage!)
            yourImage.image = UIImage(data: imageData)
        } catch {
            print("error with player image")
        }
        
        enableButtons()
    }
    
    func disableButtons() {
        self.punchButton.isEnabled = false
        self.kickButton.isEnabled = false
        self.upperCutButton.isEnabled = false
        self.goatSlapButton.isEnabled = false
        self.surrenderButton.isEnabled = false
    }
    
    func enableButtons() {
        self.punchButton.isEnabled = true
        self.kickButton.isEnabled = true
        
        if (myPokemon.pokemonLevel >= 2) {
            upperCutButton.isEnabled = true
        } else {
            upperCutButton.isEnabled = false
        }
        
        if (myPokemon.pokemonLevel >= 3) {
            goatSlapButton.isEnabled = true
        } else {
            goatSlapButton.isEnabled = false
        }
        
        self.surrenderButton.isEnabled = true
    }
    
    //MARK: - Actions
    
    @IBAction func onHelpButtonPress(_ sender: Any) {
        let popup = UIAlertController(title: "Locked Moves", message: "If you see moves that are greyed out, you must level up to be able to use them.", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
        
        popup.addAction(okButton)             // adds the button to your popup box
        
        present(popup, animated:true)
    }
    
    
    @IBAction func onAttackButtonPressed(_ sender: UIButton) {
        
        var yourAttack:Int16!
        var attackMsg:String!
        
        switch sender.tag {
        case 1:
            yourAttack = self.myPokemon.pokemonAttack - self.enemyPokemon.pokemonDefense
            attackMsg = "YOU PUNCHED FOR \(yourAttack!) DAMAGE. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
        case 2:
            yourAttack = self.myPokemon.pokemonAttack - self.enemyPokemon.pokemonDefense
            attackMsg = "YOU KICKED FOR \(yourAttack!) DAMAGE. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
        case 3:
            yourAttack = Int16(Double(self.myPokemon.pokemonAttack) * 1.1) - self.enemyPokemon.pokemonDefense
            attackMsg = "YOU UPPER CUTTED FOR \(yourAttack!) DAMAGE. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
        case 4:
            yourAttack = Int16(Double(self.myPokemon.pokemonAttack) * 1.3) - self.enemyPokemon.pokemonDefense
            attackMsg = "YOU GOAT SLAPPED FOR \(yourAttack!) DAMAGE. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
        default:
            return
        }

        self.enemyPokemon.pokemonHP -= yourAttack
        
        if(self.enemyPokemon.pokemonHP <= 0){
            
            self.enemyPokemon.pokemonHP = 0
            gameMessageLabel.text = "YOU WON. YOU GET \(self.myPokemon.pokemonLevel + 1)XP, PLUS $\(MapViewController.MONEY_GAIN). GO BACK TO BATTLE MAP TO BATTLE MORE."
            self.userMoney += MapViewController.MONEY_GAIN
            db.collection("users").document(documentID).setData([ "money": self.userMoney ], merge: true)
            db.collection("users").document(documentID).setData([ "numWins":  self.numWins + 1], merge: true)

            self.navigationItem.setHidesBackButton(false, animated: true)
            self.myPokemon.pokemonEXP += (self.myPokemon.pokemonLevel + 1)
            self.enemyHealthLabel.text = "HP: \(self.enemyPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
            self.enemyPokemon.pokemonHP = 100

        } else {
            gameMessageLabel.text = attackMsg
            self.enemyHealthLabel.text = "HP: \(self.enemyPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.enemyAttack()
            }
        }
        
        //1. build a CALayer object
        layer1 = CALayer.init()
        
        //-- set the photo, intial position, h/w layer
        layer1.contents = enemyImage.image?.cgImage    //CoreGraphics
        layer1.bounds = CGRect(x: 0.0, y: 0.0, width: 150, height: 150)
        layer1.position = CGPoint(x: 205, y: 283)
        self.view.layer.addSublayer(layer1)
        
        //self.view.frame.maxX --> to get the max width
        //self.view.frame.maxY --> to get the max height
        
        //2. build a CABasicAnimation object
        let rotateAnimation = CABasicAnimation(keyPath:"transform.rotation")
        rotateAnimation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut
        )
        
        rotateAnimation.fromValue = 0       //  start at 0 degress
        rotateAnimation.toValue = -Double.pi * 1.5  // end at 360
        
        
        rotateAnimation.duration = 0.5
        rotateAnimation.repeatCount = 3
        
        //3. Add the BasicAnimation to the CAlayer
        layer1.add(rotateAnimation,forKey:nil)
        
        disableButtons()
    
    }
    
    @IBAction func onSurrenderPress(_ sender: Any) {
        
        disableButtons()
        
        let random = Int.random(in: 0 ... 1)
        if(random == 0) {
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.gameMessageLabel.text = "SURRENDER FAILED. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.enemyAttack()
            }

        } else {
            self.navigationItem.setHidesBackButton(false, animated: true)
            self.gameMessageLabel.text = " YOU SURRENDERED AND LOST $\(MapViewController.MONEY_LOST). YOU MAY RETURN TO THE MAP WITH THE BUTTON ABOVE"
            self.userMoney -= MapViewController.MONEY_LOST
            db.collection("users").document(documentID).setData([ "money": self.userMoney ], merge: true)
        }
    }
    
    func enemyAttack() {
        
        let punchAttack = enemyPokemon.pokemonAttack
        let kickAttack = enemyPokemon.pokemonAttack
        let upperCutAttack = Double(enemyPokemon.pokemonAttack) * 1.1
        let goatSlapAttack = Double(enemyPokemon.pokemonAttack) * 1.3
        
        var attack:Int16!
        var attackMessage:String!
        
        var run:Bool = true
        var rNG:Int!
        
        if (Int16(Double(punchAttack) * 1.3) < self.myPokemon.pokemonDefense) {
            let random = Int.random(in: 0 ... 1)
            if(random == 0) {
                self.navigationItem.setHidesBackButton(true, animated: true)
                self.gameMessageLabel.text = "\(enemyPokemon.pokemonName!.uppercased())'S SURRENDER FAILED. \(String(describing: self.myPokemon.pokemonName))'S TURN"
                enableButtons()
                return
            } else {

                self.navigationItem.setHidesBackButton(false, animated: true)
                self.gameMessageLabel.text = "\(enemyPokemon.pokemonName!.uppercased()) SURRENDERED. YOU WIN \(self.myPokemon.pokemonLevel + 1) XP, PLUS $\(MapViewController.MONEY_GAIN). YOU MAY RETURN TO THE MAP WITH THE BUTTON ABOVE"
                self.userMoney += MapViewController.MONEY_GAIN
                db.collection("users").document(documentID).setData([ "money": self.userMoney ], merge: true)
                db.collection("users").document(documentID).setData([ "numWins":  self.numWins + 1], merge: true)

                self.myPokemon.pokemonEXP += (self.myPokemon.pokemonLevel + 1)
                self.enemyHealthLabel.text = "HP: \(self.enemyPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
                self.enemyPokemon.pokemonHP = 100
            }
        } else {
            while (run == true) {
                rNG = Int.random(in: 1...4)
                switch rNG {
                case 1:
                    if (punchAttack > self.myPokemon.pokemonDefense) {
                        attack = Int16(punchAttack) - self.myPokemon.pokemonDefense
                        attackMessage = "YOU GOT PUNCHED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
                        run = false
                    }
                case 2:
                    if (kickAttack > self.myPokemon.pokemonDefense) {
                        attack = Int16(kickAttack) - self.myPokemon.pokemonDefense
                        attackMessage = "YOU GOT KICKED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
                        run = false
                    }
                case 3:
                    if(Int16(upperCutAttack) > myPokemon.pokemonDefense) {
                        attack = Int16(upperCutAttack) - myPokemon.pokemonDefense
                        attackMessage = "YOU GOT UPPER CUTTED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
                        run = false
                    }
                case 4:
                    if(Int16(goatSlapAttack) > myPokemon.pokemonDefense) {
                        attack = Int16(goatSlapAttack) - myPokemon.pokemonDefense
                        attackMessage = "YOU GOT GOAT SLAPPED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
                        run = false
                    }
                default:
                    print("error with enemy attacks")
                }
                
            }
            
            self.myPokemon.pokemonHP -= attack
            
            if(self.myPokemon.pokemonHP <= 0){
                
                self.myPokemon.pokemonHP = 0
                gameMessageLabel.text = "YOU LOST, AND LOSE $\(MapViewController.MONEY_LOST). GO BACK TO THE BATTLE MAP TO REVIVE."
                self.userMoney -= MapViewController.MONEY_LOST
                db.collection("users").document(documentID).setData([ "money": self.userMoney ], merge: true)
                self.navigationItem.setHidesBackButton(false, animated: true)
                //TODO: Deduct money
                disableButtons()
            } else {
                enableButtons()
                gameMessageLabel.text = attackMessage
            }
            
            self.yourHealthLabel.text = "HP: \(self.myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        }
       
        //MARK: Animations for user being attacked
        
        //1. build a CALayer object
        layer1 = CALayer.init()
        
        //-- set the photo, intial position, h/w layer
        layer1.contents = yourImage.image?.cgImage    //CoreGraphics
        layer1.bounds = CGRect(x: 0.0, y: 0.0, width: 150, height: 150)
        layer1.position = CGPoint(x: 205, y: 615)
        self.view.layer.addSublayer(layer1)
        
        
        //2. build a CABasicAnimation object
        let rotateAnimation = CABasicAnimation(keyPath:"transform.rotation")
        rotateAnimation.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut
        )
        
        rotateAnimation.fromValue = 0       //  start at 0 degress
        rotateAnimation.toValue = -Double.pi * 2 // end at 360
        
        
        rotateAnimation.duration = 0.5
        rotateAnimation.repeatCount = 3
        
        //3. Add the BasicAnimation to the CAlayer
        layer1.add(rotateAnimation,forKey:nil)
        
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
