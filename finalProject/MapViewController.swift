//
//  MapViewController.swift
//  finalProject
//
//  Created by Mike Banks on 2018-12-06.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var myPokemon:Pokemon!
    var latitude:String!
    var longitude:String!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonLevelUpButton: UIButton!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonHPLabel: UILabel!
    @IBOutlet weak var pokemonEXPLabel: UILabel!
    @IBOutlet weak var pokemonStatsLabel: UILabel!
    @IBOutlet weak var pokemonStatusLabel: UILabel!
    
    let enemyPokemon = ["https://pokeapi.co/api/v2/pokemon/salamence/",
        "https://pokeapi.co/api/v2/pokemon/tyranitar/",
        "https://pokeapi.co/api/v2/pokemon/garchomp/",
        "https://pokeapi.co/api/v2/pokemon/rhydon/",
        "https://pokeapi.co/api/v2/pokemon/onix/"]
    
    let enemyPokemonNames = ["Salamence", "Tyranitar", "Garchomp", "Rhydon", "Onix"]
    var enemyPokemonCollection:[Pokemon] = []
    var pokemonImages:[Data] = []
    var selectedPokemonName:String!
    var selectedIndex:Int!
    
    var myContext:NSManagedObjectContext!
    
    static var MAX_HEALTH:Int = 100
    static let MAX_EXP:Int = 6
    
    func addingPins() {
        //pokemonStatsLabel.text = "\(self.pokemonStats)  HP: 100"
        
        // set up the "view" of the map
        let latitudeValue = (latitude as NSString).doubleValue
        let longitudeValue = (longitude as NSString).doubleValue
        
        // 1. Set the "center" of the view                => coordinate
        let centerCoordinate = CLLocationCoordinate2DMake(longitudeValue,latitudeValue)
        
        // 2. Set the "zoom" level                      => span
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        
        // 3. Built the "view" -> (center & zoom)       => region
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        
        // 4. Update the map to show your "view"
        mapView.setRegion(region, animated: true)
        
        // add a pin to the map
        // 1. Create a new Pin object (MKPointAnnotation)
        
        let random = Float.random(in: 0.1 ... 0.2)
        let random2 = Float.random(in: -0.4 ... -0.3)
        let random3 = Float.random(in: 0.5 ... 0.6)
        let random4 = Float.random(in: -0.8 ... -0.7)
        let random5 = Float.random(in: 0.9 ... 1)
        
        let pin = MKPointAnnotation()
        let pin2 = MKPointAnnotation()
        let pin3 = MKPointAnnotation()
        let pin4 = MKPointAnnotation()
        let pin5 = MKPointAnnotation()
        let pin6 = MKPointAnnotation()
        
        // 2. Set the coordinate of the Pin (CLLocationCoordinate)
        let coord = CLLocationCoordinate2DMake(longitudeValue,latitudeValue)
        let coord2 = CLLocationCoordinate2DMake(longitudeValue-Double(random),latitudeValue-Double(random))
        let coord3 = CLLocationCoordinate2DMake(longitudeValue-Double(random2),latitudeValue-Double(random2))
        let coord4 = CLLocationCoordinate2DMake(longitudeValue-Double(random3),latitudeValue-Double(random3))
        let coord5 = CLLocationCoordinate2DMake(longitudeValue-Double(random4),latitudeValue-Double(random4))
        let coord6 = CLLocationCoordinate2DMake(longitudeValue-Double(random5),latitudeValue-Double(random5))
        
        pin.coordinate = coord
        pin2.coordinate = coord2
        pin3.coordinate = coord3
        pin4.coordinate = coord4
        pin5.coordinate = coord5
        pin6.coordinate = coord6
        
        // 3. OPTIONAL: add a "bubble/popup"
        pin.title = self.myPokemon.pokemonName
        pin2.title = self.enemyPokemonNames[0]
        pin3.title = self.enemyPokemonNames[1]
        pin4.title = self.enemyPokemonNames[2]
        pin5.title = self.enemyPokemonNames[3]
        pin6.title = self.enemyPokemonNames[4]
        
        // 4. Add the pin to the map
        mapView.addAnnotation(pin)
        mapView.addAnnotation(pin2)
        mapView.addAnnotation(pin3)
        mapView.addAnnotation(pin4)
        mapView.addAnnotation(pin5)
        mapView.addAnnotation(pin6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (self.myPokemon.pokemonEXP >= Int16(MapViewController.MAX_EXP)) {
            self.myPokemon.pokemonEXP = Int16(MapViewController.MAX_EXP)
            pokemonLevelUpButton.isEnabled = true
            mapView.isUserInteractionEnabled = false
            mapView.isHidden = true
            self.pokemonStatusLabel.text = "LEVEL UP YOUR POKEMON TO CONTINUE!"
        }
        
        if (self.myPokemon.pokemonHP == 0) {
            self.pokemonStatusLabel.text = "HEAL YOUR POKEMON TO CONTINUE!"
            mapView.isUserInteractionEnabled = false
            mapView.isHidden = true
        }
        //TODO: Update Leaderbaords, save to the DB
        self.pokemonHPLabel.text = "HP: \(self.myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        self.pokemonEXPLabel.text = "LEVEL \(self.myPokemon.pokemonLevel) - EXP: \(self.myPokemon.pokemonEXP)/\(MapViewController.MAX_EXP)"
    }
    
    func loadPokemonImages() {
        
        //MARK: Getting Images for the random pokemons
        for iPokemon in 0..<self.enemyPokemon.count {
            
            let url = enemyPokemon[iPokemon]
            
            Alamofire.request(url,method: .get, parameters:nil).responseJSON{
                (response) in
                if(response.result.isSuccess){
                    do{
                        let json = try JSON(response.data!)
                        let imageUrl = json["sprites"]["front_default"].url!
                        let imgData:Data = try Data(contentsOf: imageUrl)
                        
                        let enemyPokemon = Pokemon(context: self.myContext)
                        
                        enemyPokemon.pokemonName = self.enemyPokemonNames[iPokemon]
                        enemyPokemon.pokemonImage = imageUrl
                        enemyPokemon.pokemonAttack = Int16.random(in: 12 ... 20)
                        enemyPokemon.pokemonDefense = Int16.random(in: 6 ... 10)
                        enemyPokemon.pokemonHP = 100
                        enemyPokemon.pokemonLevel = 3
                        enemyPokemon.pokemonEXP = 0
                        
                        self.enemyPokemonCollection.append(enemyPokemon)
                        
                        self.pokemonImages.append(imgData)
                        if (iPokemon == 4) {
                            self.addingPins()
                        }
                    }
                    catch{
                        print("error")
                        
                    }
                    
                }
                
             }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        pokemonLevelUpButton.isEnabled = false
        pokemonStatusLabel.text = ""
        mapView.isUserInteractionEnabled = true
        mapView.isHidden = false
        
        var databaseResults = [Pokemon]()
        let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        
        do {
            databaseResults = try myContext.fetch(fetchRequest)
        } catch {
            print("Cannot Fetch Bitch!")
        }
        
        for pokemon in databaseResults {
            if (self.selectedPokemonName == pokemon.pokemonName) {
                self.myPokemon = pokemon
            }
        }
        
        do {
        
            let imageData:Data = try Data(contentsOf: self.myPokemon.pokemonImage!)
            pokemonImage.image = UIImage(data: imageData)
            
            pokemonNameLabel.text = self.myPokemon.pokemonName!.uppercased()
            pokemonHPLabel.text = "HP: \(self.myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
            pokemonEXPLabel.text = "LEVEL \(self.myPokemon.pokemonLevel) - EXP: \(self.myPokemon.pokemonEXP)/\(MapViewController.MAX_EXP)"
            pokemonStatsLabel.text = "ATT: \(self.myPokemon.pokemonAttack)  DEF: \(self.myPokemon.pokemonDefense)"
            
        } catch {
            print ("Error loading selected pokemon")
        }
        loadPokemonImages()
        do {
            try myContext.save()
            print("Saved!")
        } catch {
            print("Error Saving!")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {

        if let annotationTitle = view.annotation?.title
        {
            if (annotationTitle == self.myPokemon.pokemonName) {
                return
            }
        }
        
        let pokemonFighter = (view.annotation?.title)!
        switch pokemonFighter {
            case "Salamence":
                selectedIndex = 0
            case "Tyranitar":
                selectedIndex = 1
            case "Garchomp":
                selectedIndex = 2
            case "Rhydon":
                selectedIndex = 3
            case "Onix":
                selectedIndex = 4
            default:
                return
        }
        self.performSegue(withIdentifier: "battle", sender: nil)
    }
    
    
    //MARK: Adding images to pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        if annotation.title == self.myPokemon.pokemonName {
            annotationView?.image = self.pokemonImage.image
        }
        else if  annotation.title == "Salamence" {
            annotationView?.image = UIImage(data: pokemonImages[0])
        }
        else if  annotation.title == "Tyranitar" {
            annotationView?.image = UIImage(data: pokemonImages[1])
        }
        else if  annotation.title == "Garchomp" {
            annotationView?.image = UIImage(data: pokemonImages[2])
        }
        else if  annotation.title == "Rhydon" {
            annotationView?.image = UIImage(data: pokemonImages[3])
        }
        else if  annotation.title == "Onix" {
            annotationView?.image = UIImage(data: pokemonImages[4])
        }
        annotationView?.canShowCallout = true
        return annotationView!
    }
    
    //MARK: - Actions
    
    @IBAction func onLevelUpPress(_ sender: Any) {
        
        self.pokemonLevelUpButton.isEnabled = false
        
        self.myPokemon.pokemonEXP = 0
        self.myPokemon.pokemonLevel += 1
        self.myPokemon.pokemonAttack += 3
        self.myPokemon.pokemonDefense += 2
        
        for iPokemon in 0..<enemyPokemonCollection.count {
            enemyPokemonCollection[iPokemon].pokemonAttack += 2
            enemyPokemonCollection[iPokemon].pokemonDefense += 1
            enemyPokemonCollection[iPokemon].pokemonHP += 5
        }
        
        MapViewController.MAX_HEALTH += 5
        self.myPokemon.pokemonHP = Int16(MapViewController.MAX_HEALTH)
        
        pokemonEXPLabel.text = "LEVEL \(self.myPokemon.pokemonLevel) - EXP: \(self.myPokemon.pokemonEXP)/\(MapViewController.MAX_EXP)"
        pokemonStatsLabel.text = "ATT: \(self.myPokemon.pokemonAttack)  DEF: \(self.myPokemon.pokemonDefense)"
        pokemonHPLabel.text = "HP: \(self.myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        
        updateStats()
        
        self.pokemonStatusLabel.text = ""
        mapView.isUserInteractionEnabled = true
        mapView.isHidden = false
    }
    
    
    
    func updateStats(){
        
        let popup = UIAlertController(title: "Level Up", message: "Congrats, you have reached Level \(self.myPokemon.pokemonLevel). Your updateed stats: ATT: \(self.myPokemon.pokemonAttack), DEF: \(self.myPokemon.pokemonDefense), HP: \(self.myPokemon.pokemonHP)", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
        
        popup.addAction(okButton)             // adds the button to your popup box
        
        present(popup, animated:true)
        
    }
    
    @IBAction func onHospitalPress(_ sender: Any) {
        //TODO: Charge the user money! no free healthcare this aint Canada
        self.myPokemon.pokemonHP = Int16(MapViewController.MAX_HEALTH)
        pokemonHPLabel.text = "HP: \(self.myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
        
        self.pokemonStatusLabel.text = ""
        mapView.isUserInteractionEnabled = true
        mapView.isHidden = false
    }
    
    @IBAction func onLeaderboardsPress(_ sender: Any) {
        //TODO:
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let battleViewController = segue.destination as! BattleViewController
        
        battleViewController.enemyPokemon = self.enemyPokemonCollection[selectedIndex]
        battleViewController.myPokemon = self.myPokemon
        
    }

}
