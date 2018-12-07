//
//  MapViewController.swift
//  finalProject
//
//  Created by Mike Banks on 2018-12-06.
//  Copyright © 2018 Salim Elewa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var pokemonImageData:UIImage!
    var pokemonName:String!
    var pokemonStats:String!
    var latitude:String!
    var longitude:String!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonStatsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonImage.image = pokemonImageData
        pokemonNameLabel.text = self.pokemonName
        //pokemonStatsLabel.text = "\(self.pokemonStats)  HP: 100"
        
        // set up the "view" of the map
        let latitudeValue = (latitude as NSString).doubleValue
        let longitudeValue = (longitude as NSString).doubleValue
        
        // 1. Set the "center" of the view                => coordinate
        let centerCoordinate = CLLocationCoordinate2DMake(longitudeValue,latitudeValue)
        
        // 2. Set the "zoom" level                      => span
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        // 3. Built the "view" -> (center & zoom)       => region
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        
        // 4. Update the map to show your "view"
        mapView.setRegion(region, animated: true)
        
        // add a pin to the map
        // 1. Create a new Pin object (MKPointAnnotation)
        let pin = MKPointAnnotation()
        
        
        // 2. Set the coordinate of the Pin (CLLocationCoordinate)
        let coord = CLLocationCoordinate2DMake(longitudeValue,latitudeValue)
        pin.coordinate = coord
        
        // 3. OPTIONAL: add a "bubble/popup"
        pin.title = self.pokemonName
        
        // 4. Add the pin to the map
        mapView.addAnnotation(pin)
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
