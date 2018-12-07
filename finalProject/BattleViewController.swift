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
    
    var pokemonAttacker:String!
    var pokemonAttackerImage:Data!
    var pokemonLevel:Int!
    
    var yourName:String!
    var yourStats:String!
    var yourImageData:UIImage!
    
    //MARK: - Default Functiom
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //**** TEMP ****
        pokemonLevel = 1
        //**************
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        enemyNameLabel.text = pokemonAttacker
        let attack = Int.random(in: 12 ... 20)
        let defense = Int.random(in: 12 ... 20)
        enemyStatsLabel.text = "ATT: \(attack)  DEF: \(defense)"
        enemyImage.image = UIImage(data: pokemonAttackerImage)
        
        gameMessageLabel.text = "YOUR MOVE FIRST"
        
        yourNameLabel.text = yourName
        yourStatsLabel.text = yourStats
        yourImage.image = yourImageData!
        
        if (pokemonLevel >= 2) {
            upperCutButton.isEnabled = true
        } else {
            upperCutButton.isEnabled = false
        }
        
        if (pokemonLevel >= 3) {
            goatSlapButton.isEnabled = true
        } else {
            goatSlapButton.isEnabled = false
        }
    }
    
    //MARK: - Actions
    
    @IBAction func onPunchPress(_ sender: Any) {
    }
    
    @IBAction func onKickPress(_ sender: Any) {
    }
    
    @IBAction func onUpperCutPress(_ sender: Any) {
    }
    
    @IBAction func onGoatSlapPress(_ sender: Any) {
    }
    
    @IBAction func onSurrenderPress(_ sender: Any) {
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
