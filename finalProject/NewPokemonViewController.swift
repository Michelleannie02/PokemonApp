//
//  NewPokemonViewController.swift
//  finalProject
//
//  Created by Salim Elewa on 2018-12-16.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import Firebase
import FirebaseFirestore

class NewPokemonViewController: UIViewController {
    
    @IBOutlet var pokemonName: UITextField!
    
    @IBOutlet var pokemonImage: UIImageView!
    
    @IBOutlet var infoLabel: UILabel!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func downloadPokemonPressed(_ sender: Any) {
        if(pokemonName.text?.isEmpty == true){
            let popup = UIAlertController(title: "Alert", message: "You have to provide a name!", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
            
            popup.addAction(okButton)             // adds the button to your popup box
            
            self.present(popup, animated:true)
        }
        else {
            let name = pokemonName.text?.lowercased()
            let url = "https://pokeapi.co/api/v2/pokemon/\(name!)/"
            print(url)
            // ALAMOFIRE FUNCTION: get the data from the website
            Alamofire.request(url, method: .get, parameters: nil).responseJSON{
                (response) in
                if (response.result.isSuccess) {
                    let json = JSON(response.data!)
                    print(json)
                    let imageURL = json["sprites"]["front_default"].url!
                    let pokemon = Pokemon(context: self.myContext)
                    
                    pokemon.pokemonName = self.pokemonName.text
                    pokemon.pokemonImage = imageURL
                    pokemon.pokemonAttack = Int16.random(in: 12 ... 20)
                    pokemon.pokemonDefense = Int16.random(in: 6 ... 10)
                    pokemon.pokemonHP = 100
                    pokemon.pokemonLevel = 1
                    pokemon.pokemonEXP = 0
                    do {
                        try self.myContext.save()
                        print("Saved!")
                    } catch {
                        print("Error Saving!")
                    }
                    self.navigationItem.setHidesBackButton(false, animated: true)
                    
                    do {
                        let imgData:Data = try Data(contentsOf: imageURL)
                        self.pokemonImage.image = UIImage(data: imgData)
                        self.infoLabel.text = "ATT: \(pokemon.pokemonAttack)  DEF: \(pokemon.pokemonDefense)"
                    } catch {
                        print("error")
                    }
                    
                }
                else if(response.result.isFailure){
                    let popup = UIAlertController(title: "Alert", message: "You have to provide an actual Pokeman name!", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
                    
                    popup.addAction(okButton)             // adds the button to your popup box
                    
                    self.present(popup, animated:true)
                }
            }
        }

    }

}
