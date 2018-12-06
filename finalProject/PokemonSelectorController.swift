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

    @IBOutlet var pokemonImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let url = "https://pokeapi.co/api/v2/pokemon/pikachu/"
        // ALAMOFIRE FUNCTION: get the data from the website
        Alamofire.request(url, method: .get, parameters: nil).responseJSON{
            (response) in
            if (response.result.isSuccess) {
                print("Got response back.")
                print("---------------------")
                print(response.data!)
                
                do{
                    let json = try JSON(response.data!)
                    print(json["sprites"]["front_default"])
                    //let imageUrl = json["sprites"]["front_default"]
                    //self.pokemonImage.image = UIImage(data: imageUrl)
                }catch {
                    print("error")
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
