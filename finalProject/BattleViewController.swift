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
        self.upperCutButton.isEnabled = true
        self.goatSlapButton.isEnabled = true
        self.surrenderButton.isEnabled = true
    }
    
    //MARK: - Actions
    
    @IBAction func onPunchPress(_ sender: Any) {
        
        let yourAttack = self.myPokemon.pokemonAttack - self.enemyPokemon.pokemonDefense
        gameMessageLabel.text = "YOU PUNCHED FOR \(yourAttack) DAMAGE. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
        disableButtons()
        enemyAttack()
    }
    
    @IBAction func onKickPress(_ sender: Any) {
        
        let yourAttack = self.myPokemon.pokemonAttack - self.enemyPokemon.pokemonDefense
        gameMessageLabel.text = "YOU KICKED FOR \(yourAttack) DAMAGE. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
        disableButtons()
        enemyAttack()
    }
    
    @IBAction func onUpperCutPress(_ sender: Any) {
        let yourAttack = (Double(self.myPokemon.pokemonAttack) * 1.1) - Double(self.enemyPokemon.pokemonDefense)
        gameMessageLabel.text = "YOU UPPER CUTTED FOR \(yourAttack) DAMAGE. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
        disableButtons()
        enemyAttack()
    }
    
    @IBAction func onGoatSlapPress(_ sender: Any) {
        let yourAttack = (Double(self.myPokemon.pokemonAttack) * 1.3) - Double(self.enemyPokemon.pokemonDefense)
        gameMessageLabel.text = "YOU GOAT SLAPPED FOR \(yourAttack) DAMAGE. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
        disableButtons()
        enemyAttack()
    }
    
    @IBAction func onSurrenderPress(_ sender: Any) {
        
        disableButtons()
        
        let random = Int.random(in: 0 ... 1)
        if(random == 0) {
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.gameMessageLabel.text = "SURRENDER FAILED. \(enemyPokemon.pokemonName!.uppercased())'S TURN"
            enemyAttack()
        } else {
            self.navigationItem.setHidesBackButton(false, animated: true)
            self.gameMessageLabel.text = "SURRENDERED. YOU MAY RETURN TO THE MAP WITH THE BUTTON ABOVE"
        }
    }
    
    
    func enemyAttack() {
        
        let kickAttack = enemyPokemon.pokemonAttack
        let punchAttack = enemyPokemon.pokemonAttack
        let upperCutAttack = Double(enemyPokemon.pokemonAttack) * 1.1
        let goatSlapAttack = Double(enemyPokemon.pokemonAttack) * 1.3
        
        if(kickAttack > myPokemon.pokemonDefense) {
            let yourAttack = kickAttack - myPokemon.pokemonDefense
            gameMessageLabel.text = "YOU GOT KICKED FOR \(yourAttack) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
        }
        else if(punchAttack > myPokemon.pokemonDefense) {
            let yourAttack = punchAttack - myPokemon.pokemonDefense
            gameMessageLabel.text = "YOU GOT PUNCHED FOR \(yourAttack) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
        }
        else if(Int16(upperCutAttack) > myPokemon.pokemonDefense) {
            let yourAttack = upperCutAttack - Double(myPokemon.pokemonDefense)
            gameMessageLabel.text = "YOU GOT UPPER CUTTED FOR \(yourAttack) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
        }
        else if(Int16(goatSlapAttack) > myPokemon.pokemonDefense) {
            let yourAttack = upperCutAttack - Double(myPokemon.pokemonDefense)
            gameMessageLabel.text = "YOU GOT GOAT SLAPPED FOR \(yourAttack) DAMAGE. \(myPokemon.pokemonName!.uppercased())'S TURN"
        }
        
        enableButtons()
        
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
