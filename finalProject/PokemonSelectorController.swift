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
    
    @IBOutlet weak var pikachuNameLabel: UILabel!
    @IBOutlet weak var eeveeNameLabel: UILabel!
    @IBOutlet weak var snorlaxNameLabel: UILabel!
    @IBOutlet weak var charizardNameLabel: UILabel!
    @IBOutlet weak var charmanderNameLabel: UILabel!
    @IBOutlet weak var squirtleNameLabel: UILabel!
    @IBOutlet weak var bulbasaurNameLabel: UILabel!
    @IBOutlet weak var blastoiseNameLabel: UILabel!
    
    @IBOutlet weak var pikachuLabel: UILabel!
    @IBOutlet weak var eeveeLabel: UILabel!
    @IBOutlet weak var snorlaxLabel: UILabel!
    @IBOutlet weak var charizardLabel: UILabel!
    @IBOutlet weak var charmanderLabel: UILabel!
    @IBOutlet weak var squirtleLabel: UILabel!
    @IBOutlet weak var bulbasaurLabel: UILabel!
    @IBOutlet weak var blastoiseLabel: UILabel!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var name:String!
    var selectedIndex:Int!
    var long:String!
    var lat:String!
    
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
    func enterLocation(){
        print(long)
        print(lat)
        let popup = UIAlertController(title: "Add a location", message: "longitude and latitude", preferredStyle: .alert)
        
        popup.addTextField()
        popup.addTextField()
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)  // creating & configuring the button
        let saveButton = UIAlertAction(title: "Save", style: .default, handler: {
            action in
            do{
                self.long = popup.textFields?[0].text
                self.lat = popup.textFields?[1].text
                self.performSegue(withIdentifier: "segueMap", sender: nil)
                
            }
            catch{
                print("error")
            }})
        
        popup.addAction(saveButton)             // adds the button to your popup box
        popup.addAction(cancelButton)
        
        // 4. Show the alert box!
        present(popup, animated:true)
        
        print(long)
        print(lat)
        
    }
    
    
    
    //Unfortunately we need to have individual actions for each gesture, I tried many times to put it into one method but it just doesn't work.
    @IBAction func onPikachuPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 0
        enterLocation()
    }
    @IBAction func onEeveePress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 1
        enterLocation()
    }
    @IBAction func onSnorlaxPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 2
        enterLocation()
    }
    @IBAction func onCharizardPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 3
        enterLocation()
    }
    @IBAction func onCharmanderPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 4
        enterLocation()
    }
    @IBAction func onSquirtlePress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 5
        enterLocation()
    }
    @IBAction func onBulbasaurPress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 6
        enterLocation()
    }
    @IBAction func onBlastoisePress(_ sender: UITapGestureRecognizer) {
        selectedIndex = 7
        enterLocation()
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let imageOutlets:[UIImageView] = [self.pikachuImage, self.eeveeImage, self.snorlaxImage, self.charizardImage, self.charmanderImage, self.squirtleImage, self.bulbasaurImage, self.blastoiseImage]
        
        let labelOutlets:[UILabel] = [self.pikachuLabel, self.eeveeLabel, self.snorlaxLabel, self.charizardLabel, self.charmanderLabel, self.squirtleLabel, self.bulbasaurLabel, self.blastoiseLabel]
        
        let nameOutlets:[UILabel] = [self.pikachuNameLabel, self.eeveeNameLabel, self.snorlaxNameLabel, self.charizardNameLabel, self.charmanderNameLabel, self.squirtleNameLabel, self.bulbasaurNameLabel, self.blastoiseNameLabel]
        
        let destinationNavigationController = segue.destination as! UINavigationController
        let targetController = destinationNavigationController.topViewController as! MapViewController
        
        do {
            targetController.pokemonImageData = imageOutlets[selectedIndex].image
            targetController.pokemonName = nameOutlets[selectedIndex].text
            targetController.pokemonStats = labelOutlets[selectedIndex].text
            targetController.longitude = long
            targetController.latitude = lat
            
            //TODO: FIX MEEEEEEEEE
            //mapViewController.pokemonStats = statsOutlets[selectedIndex].text
            
        } catch {
            print ("error with selected pokemon")
        }
        
    }
    

}
