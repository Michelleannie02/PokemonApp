//
//  MapViewController.swift
//  finalProject
//
//  Created by Mike Banks on 2018-12-06.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    var pokemonImageData:UIImage!
    var pokemonName:String!
    var pokemonStats:String!
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonStatsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonImage.image = pokemonImageData
        pokemonNameLabel.text = self.pokemonName
        //pokemonStatsLabel.text = "\(self.pokemonStats)  HP: 100"
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
