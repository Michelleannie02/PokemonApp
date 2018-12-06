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

        loadPokemon()
        
    }
    
    func loadPokemon() {
        
        let imageOutlets:[UIImageView] = [self.pikachuImage, self.eeveeImage, self.snorlaxImage, self.charizardImage, self.charmanderImage, self.squirtleImage, self.bulbasaurImage, self.blastoiseImage]
        
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
                    }catch {
                        print("error with JSON")
                    }
                }
                
                
            }
        }
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
