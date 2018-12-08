//
//  BattleViewController.swift
//  finalProject
//
//  Created by Salim Elewa on 2018-12-07.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit

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
        
    //MARK: - Default Functiom
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        enemyPokemon.pokemonHP -= yourAttack
        enemyHealthLabel.text = "HP: \(enemyPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        
        gameMessageLabel.text = attackMsg
        
        disableButtons()
        
        //erform(Selector("enemyAttack"), with: nil, afterDelay: 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.enemyAttack()
        }
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
            //perform(Selector("enemyAttack"), with: nil, afterDelay: 3)
        } else {
            self.navigationItem.setHidesBackButton(false, animated: true)
            self.gameMessageLabel.text = " YOU SURRENDERED. YOU MAY RETURN TO THE MAP WITH THE BUTTON ABOVE"
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
        
        while (run == true) {
            rNG = Int.random(in: 1...4)
            switch rNG {
                case 1:
                    if (punchAttack >= self.myPokemon.pokemonDefense) {
                        attack = Int16(punchAttack) - self.myPokemon.pokemonDefense
                        attackMessage = "YOU GOT PUNCHED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
                        run = false
                    }
                case 2:
                    if (kickAttack >= self.myPokemon.pokemonDefense) {
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
                        attack = Int16(upperCutAttack) - myPokemon.pokemonDefense
                        attackMessage = "YOU GOT GOAT SLAPPED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
                        run = false
                    }
                default:
                    print("error with enemy attacks")
            }
            
        }
        
        self.myPokemon.pokemonHP -= attack
        self.yourHealthLabel.text = "HP: \(self.myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        
        gameMessageLabel.text = attackMessage
        
        enableButtons()
        
        /*
        if(kickAttack > myPokemon.pokemonDefense) {
            attack = Int16(kickAttack) - self.myPokemon.pokemonDefense
            attackMessage = "YOU GOT KICKED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
        }
        else if(punchAttack > myPokemon.pokemonDefense) {
            attack = Int16(punchAttack) - self.myPokemon.pokemonDefense
            attackMessage = "YOU GOT PUNCHED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
        }
        else if(Int16(upperCutAttack) > myPokemon.pokemonDefense) {
            attack = Int16(upperCutAttack) - myPokemon.pokemonDefense
            attackMessage = "YOU GOT UPPER CUTTED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
        }
        else if(Int16(goatSlapAttack) > myPokemon.pokemonDefense) {
            attack = Int16(upperCutAttack) - myPokemon.pokemonDefense
            attackMessage = "YOU GOT GOAT SLAPPED FOR \(attack!) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
        }
        
        self.myPokemon.pokemonHP -= attack
        self.yourHealthLabel.text = "HP: \(self.myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        
        gameMessageLabel.text = attackMessage
        
        enableButtons()
        */
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
