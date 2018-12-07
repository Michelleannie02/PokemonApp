//
//  PokemonSelectorViewController.swift
//  finalProject
//
//  Created by Salim Elewa on 2018-12-06.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PokemonSelectorController: UIViewController {

    @IBOutlet weak var pikachuImage: UIImageView!
    @IBOutlet weak var eeveeImage: UIImageView!
    @IBOutlet weak var snorlaxImage: UIImageView!
    @IBOutlet weak var charizardImage: UIImageView!
    @IBOutlet weak var charmanderImage: UIImageView!
    @IBOutlet weak var squirtleImage: UIImageView!
    @IBOutlet weak var bulbasaurImage: UIImageView!
    @IBOutlet weak var blastoiseImage: UIImageView!
    
    @IBOutlet weak var pikachuLabel: UILabel!
    @IBOutlet weak var eeveeLabel: UILabel!
    @IBOutlet weak var snorlaxLabel: UILabel!
    @IBOutlet weak var charizardLabel: UILabel!
    @IBOutlet weak var charmanderLabel: UILabel!
    @IBOutlet weak var squirtleLabel: UILabel!
    @IBOutlet weak var bulbasaurLabel: UILabel!
    @IBOutlet weak var blastoiseLabel: UILabel!
    
    @IBOutlet weak var pikachuStatsLabel: UILabel!
    @IBOutlet weak var eeveeStatsLabel: UILabel!
    @IBOutlet weak var snorlaxStatsLabel: UILabel!
    @IBOutlet weak var charizardStatsLabel: UILabel!
    @IBOutlet weak var charmanderStatsLabel: UILabel!
    @IBOutlet weak var squirtleStatsLabel: UILabel!
    @IBOutlet weak var bulbasaurStatsLabel: UILabel!
    @IBOutlet weak var blastoiseStatsLabel: UILabel!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var name:String!
    var selectedIndex:Int!
    
    let pokemonImages = ["https://pokeapi.co/api/v2/pokemon/pikachu/",
                         "https://pokeapi.co/api/v2/pokemon/eevee/",
                         "https://pokeapi.co/api/v2/pokemon/snorlax/",
                         "https://pokeapi.co/api/v2/pokemon/charizard/",
                         "https://pokeapi.co/api/v2/pokemon/charmander/",
                         "https://pokeapi.co/api/v2/pokemon/squirtle/",
                         "https://pokeapi.co/api/v2/pokemon/bulbasaur/",
                         "https://pokeapi.co/api/v2/pokemon/blastoise/"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //***CHANGE ME***
        //welcomeLabel.text = "Welcome \(self.name!), pick a Pokemon"
        welcomeLabel.text = "Welcome, pick a Pokemon"
        loadPokemon()
    }
    
    func loadPokemon() {
        
        let imageOutlets:[UIImageView] = [self.pikachuImage, self.eeveeImage, self.snorlaxImage, self.charizardImage, self.charmanderImage, self.squirtleImage, self.bulbasaurImage, self.blastoiseImage]
        
        let labelOutlets:[UILabel] = [self.pikachuLabel, self.eeveeLabel, self.snorlaxLabel, self.charizardLabel, self.charmanderLabel, self.squirtleLabel, self.bulbasaurLabel, self.blastoiseLabel]
        
        for iPokemon in 0..<self.pokemonImages.count {
            
            let url = pokemonImages[iPokemon]
            
            // ALAMOFIRE FUNCTION: get the data from the website
            Alamofire.request(url, method: .get, parameters: nil).responseJSON{
                (response) in
                if (response.result.isSuccess) {
                    do{
                        
                        let json = try JSON(response.data!)
                        let imageUrl = json["sprites"]["front_default"].url!
                        let imgData:Data = try Data(contentsOf: imageUrl)
                        
                        var image = UIImage(data: imgData)
                        
                        imageOutlets[iPokemon].image = UIImage(data: imgData)
                        let attack = Int.random(in: 12 ... 20)
                        let defense = Int.random(in: 12 ... 20)
                        
                        labelOutlets[iPokemon].text = "ATT: \(attack)  DEF: \(defense)"
                        
                        
                    }catch {
                        print("error with JSON")
                    }
                }
                
            }
        }
    }
    
    //MARK: - Actions
    
    //Unfortunately we need to have individual actions for each gesture, I tried many times to put it into one method but it just doesn't work.
    @IBAction func onPikachuPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 0
        performSegue(withIdentifier: "segueMap", sender: nil)
    }
    @IBAction func onEeveePress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 1
        performSegue(withIdentifier: "segueMap", sender: nil)
    }
    @IBAction func onSnorlaxPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 2
        performSegue(withIdentifier: "segueMap", sender: nil)
    }
    @IBAction func onCharizardPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 3
        performSegue(withIdentifier: "segueMap", sender: nil)
    }
    @IBAction func onCharmanderPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 4
        performSegue(withIdentifier: "segueMap", sender: nil)
    }
    @IBAction func onSquirtlePress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 5
        performSegue(withIdentifier: "segueMap", sender: nil)
    }
    @IBAction func onBulbasaurPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 6
        performSegue(withIdentifier: "segueMap", sender: nil)
    }
    @IBAction func onBlastoisePress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 7
        performSegue(withIdentifier: "segueMap", sender: nil)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let imageOutlets:[UIImageView] = [self.pikachuImage, self.eeveeImage, self.snorlaxImage, self.charizardImage, self.charmanderImage, self.squirtleImage, self.bulbasaurImage, self.blastoiseImage]
        
        let labelOutlets:[UILabel] = [self.pikachuLabel, self.eeveeLabel, self.snorlaxLabel, self.charizardLabel, self.charmanderLabel, self.squirtleLabel, self.bulbasaurLabel, self.blastoiseLabel]
        
        var mapViewController = segue.destination as! MapViewController
        
        do {
            mapViewController.pokemonImageData = imageOutlets[selectedIndex].image
            mapViewController.pokemonName = labelOutlets[selectedIndex].text
            
            //TODO: FIX MEEEEEEEEE
            //mapViewController.pokemonStats = statsOutlets[selectedIndex].text
            
        } catch {
            print ("error with selected pokemon")
        }
        
    }
    

}
