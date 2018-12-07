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


class MapViewController: UIViewController, MKMapViewDelegate {
    
    var pokemonImageData:UIImage!
    var pokemonName:String!
    var pokemonStats:String!
    var latitude:String!
    var longitude:String!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonStatsLabel: UILabel!
    
    let fightPokemon = ["https://pokeapi.co/api/v2/pokemon/salamence/",
        "https://pokeapi.co/api/v2/pokemon/tyranitar/",
        "https://pokeapi.co/api/v2/pokemon/garchomp/",
        "https://pokeapi.co/api/v2/pokemon/rhydon/",
        "https://pokeapi.co/api/v2/pokemon/onix/"]
    
    var pokemonFighter:String!
    var enemyImageData:Data!
    
    var pokemonImages:[Data] = []
    
    //MARK: TODO: CHECK USER INPUT FOR LOCATION
    
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
        pin.title = self.pokemonName
        pin2.title = "Salamence"
        pin3.title = "Tyranitar"
        pin4.title = "Garchomp"
        pin5.title = "Rhydon"
        pin6.title = "Onix"
        
        // 4. Add the pin to the map
        mapView.addAnnotation(pin)
        mapView.addAnnotation(pin2)
        mapView.addAnnotation(pin3)
        mapView.addAnnotation(pin4)
        mapView.addAnnotation(pin5)
        mapView.addAnnotation(pin6)
    }
    
    func loadPokemonImages() {
        
        //MARK: Getting Images for the random pokemons
        for iPokemon in 0..<self.fightPokemon.count {
            
            let url = fightPokemon[iPokemon]
            
            Alamofire.request(url,method: .get, parameters:nil).responseJSON{
                (response) in
                if(response.result.isSuccess){
                    print("got sucess")
                    do{
                        let json = try JSON(response.data!)
                        let imageUrl = json["sprites"]["front_default"].url!
                        let imgData:Data = try Data(contentsOf: imageUrl)
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
        
        pokemonImage.image = self.pokemonImageData
        pokemonNameLabel.text = self.pokemonName
        pokemonStatsLabel.text = self.pokemonStats
        
        loadPokemonImages()
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {

        if let annotationTitle = view.annotation?.title
        {
            if (annotationTitle == self.pokemonName) {
                return
            }
        }
        
        pokemonFighter = (view.annotation?.title)!
        switch pokemonFighter {
            case "Salamence":
                self.enemyImageData = pokemonImages[0]
            case "Tyranitar":
                self.enemyImageData = pokemonImages[1]
            case "Garchomp":
                self.enemyImageData = pokemonImages[2]
            case "Rhydon":
                self.enemyImageData = pokemonImages[3]
            case "Onix":
                self.enemyImageData = pokemonImages[4]
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
        if annotation.title == self.pokemonName {
            annotationView?.image = self.pokemonImageData
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var battleViewController = segue.destination as! BattleViewController
        
        
        battleViewController.pokemonAttacker = self.pokemonFighter
        battleViewController.pokemonAttackerImage = self.enemyImageData
        
        battleViewController.yourName = self.pokemonName
        battleViewController.yourStats = self.pokemonStats
        battleViewController.yourImageData = self.pokemonImageData
        
    }

}
