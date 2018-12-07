//
//  MapViewController.swift
//  finalProject
//
//  Created by Mike Banks on 2018-12-06.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    var pokemonImage:Data!
    var pokemonName:String!
    var pokemonStats:String!
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonAttackLabel: UILabel!
    @IBOutlet weak var pokemonDefenseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
