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
import Firebase
import FirebaseFirestore

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
    @IBOutlet var userInfoLabel: UILabel!
    
    
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
    var userName:String!
    var userMoney:Int!
    var documentID:String!
    var numWins:Int!
    
    var myContext:NSManagedObjectContext!
    var db:Firestore!
    
    var users:[User] = []
    
    static var MAX_HEALTH:Int = 100
    static let MAX_EXP:Int = 6
    static var MONEY_GAIN:Int = 10
    static var MONEY_LOST:Int = 10
    
    func addingPins() {
        //pokemonStatsLabel.text = "\(self.pokemonStats)  HP: 100"
        
        // set up the "view" of the map
        let latitudeValue = (latitude as NSString).doubleValue
        let longitudeValue = (longitude as NSString).doubleValue
        
        // 1. Set the "center" of the view                => coordinate
        let centerCoordinate = CLLocationCoordinate2DMake(longitudeValue,latitudeValue)
        
        // 2. Set the "zoom" level                      => span
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        
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
        
        let personPin1 = MKPointAnnotation()
        let personPin2 = MKPointAnnotation()
        let personPin3 = MKPointAnnotation()
        
        let randomP1 = Float.random(in: -0.25 ... 0.6)
        let randomP2 = Float.random(in: -0.05 ... 0.3)
        let randomP3 = Float.random(in: -0.35 ... 0.75)
        
        let coordP1 = CLLocationCoordinate2DMake(longitudeValue-Double(randomP1),latitudeValue-Double(randomP1))
        let coordP2 = CLLocationCoordinate2DMake(longitudeValue-Double(randomP2),latitudeValue-Double(randomP2))
        let coordP3 = CLLocationCoordinate2DMake(longitudeValue-Double(randomP3),latitudeValue-Double(randomP3))
        
        // 2. Set the coordinate of the Pin (CLLocationCoordinate)
        let coord = CLLocationCoordinate2DMake(longitudeValue,latitudeValue)
        let coord2 = CLLocationCoordinate2DMake(longitudeValue-Double(random),latitudeValue-Double(random))
        let coord3 = CLLocationCoordinate2DMake(longitudeValue-Double(random2),latitudeValue-Double(random2))
        let coord4 = CLLocationCoordinate2DMake(longitudeValue-Double(random3),latitudeValue-Double(random3))
        let coord5 = CLLocationCoordinate2DMake(longitudeValue-Double(random4),latitudeValue-Double(random4))
        let coord6 = CLLocationCoordinate2DMake(longitudeValue-Double(random5),latitudeValue-Double(random5))
        
        personPin1.coordinate = coordP1
        personPin2.coordinate = coordP2
        personPin3.coordinate = coordP3
        
        pin.coordinate = coord
        pin2.coordinate = coord2
        pin3.coordinate = coord3
        pin4.coordinate = coord4
        pin5.coordinate = coord5
        pin6.coordinate = coord6
        
        personPin1.title = "Xavier"
        personPin2.title = "Johnny"
        personPin3.title = "Mary"
        
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
        
        mapView.addAnnotation(personPin1)
        mapView.addAnnotation(personPin2)
        mapView.addAnnotation(personPin3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        do {
            let imgData:Data = try Data(contentsOf: myPokemon.pokemonImage!)
            self.pokemonImage.image = UIImage(data: imgData)
        } catch {
            print("error")
        }
        print(myPokemon.pokemonImage!)
        
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
        
        
        let docRef = db.collection("users").document(self.documentID!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let money = document.data()!["money"]
                self.userMoney = (money as! Int)
                self.numWins = document.data()!["numWins"] as? Int
                print(self.userMoney!)
                self.userInfoLabel.text = "\(self.userName!)\nMoney: $\(self.userMoney!)\nWins: \(self.numWins!)"
                if(self.userMoney <= 0 )
                {
                    let popup = UIAlertController(title: "Alert", message: "You are out of money! Play a match to get some", preferredStyle: .alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
                    
                    popup.addAction(okButton)             // adds the button to your popup box
                    
                    self.present(popup, animated:true)
                }
            }
            else {
                print("Document does not exist")
                print(self.documentID)
            }
        }
        
        self.users.removeAll()
        
        db.collection("users").order(by: "numWins", descending: true).getDocuments {
            (querySnapshot, err) in
            if (err != nil) {
                print("Error!")
                print(err?.localizedDescription)
            }
            else {
                
                for user in (querySnapshot?.documents)! {
                    
                    let currentUser = user.data();
                    
                    let usr:User = User()
                    usr.email = currentUser["email"] as? String
                    usr.numWins = currentUser["numWins"] as? Int
                    
                    self.users.append(usr)
                    //self.users = self.users.sorted(by: { $0.numWins > $1.numWins })
                }
                
            }
        }

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
        db = Firestore.firestore()
        //self.userInfoLabel.text = "Player: \(self.userName!)\nMoney: $\(self.userMoney!)"

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
            print("Cannot Fetch!")
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
        if (annotation.title == "Xavier") {
            var image = UIImage(named: "player")
            //TODO: Change the size of the image
            
            annotationView?.image = image
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
        
        MapViewController.MONEY_LOST += 5
        MapViewController.MONEY_GAIN += 5
        
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
        
        let popup = UIAlertController(title: "Level Up", message: "Congrats, you have reached Level \(self.myPokemon.pokemonLevel). Your updated stats: ATT: \(self.myPokemon.pokemonAttack), DEF: \(self.myPokemon.pokemonDefense), HP: \(self.myPokemon.pokemonHP)", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
        
        popup.addAction(okButton)             // adds the button to your popup box
        
        present(popup, animated:true)
        
    }
    
    @IBAction func onHospitalPress(_ sender: Any) {
        //Charge the user money! no free healthcare we aint in Canada no more
        if(myPokemon.pokemonHP == MapViewController.MAX_HEALTH){
            let popup = UIAlertController(title: "Alert", message: "You are already at Max Health!", preferredStyle: .alert)
            
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
            
            popup.addAction(okButton)             // adds the button to your popup box
            
            present(popup, animated:true)
        }
        else{
            self.userMoney -= MapViewController.MONEY_LOST
            if(userMoney <= 0 )
            {
                let popup = UIAlertController(title: "Alert", message: "You are out of money! Play a match to get some", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
                
                popup.addAction(okButton)             // adds the button to your popup box
                
                present(popup, animated:true)
            }
            else {
                db.collection("users").document(documentID).setData([ "money": self.userMoney ], merge: true)
                
                self.myPokemon.pokemonHP = Int16(MapViewController.MAX_HEALTH)
                pokemonHPLabel.text = "HP: \(self.myPokemon.pokemonHP)/\(MapViewController.MAX_HEALTH)"
                self.userInfoLabel.text = "\(self.userName!)\nMoney: $\(self.userMoney!)\nWins: \(self.numWins!)"
                self.pokemonStatusLabel.text = ""
                mapView.isUserInteractionEnabled = true
                mapView.isHidden = false
                
                let popup = UIAlertController(title: "Heal Successful", message: "Healed for $\(MapViewController.MONEY_LOST)", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)  // creating & configuring the button
                
                popup.addAction(okButton)             // adds the button to your popup box
                
                present(popup, animated:true)
            }
        }
    }
    
    
    @IBAction func addNewPokemonPressed(_ sender: Any) {
        //segueNewPokemon
        performSegue(withIdentifier: "segueNewPokemon", sender: self)

    }
    
    
    @IBAction func onLeaderboardsPress(_ sender: Any) {
        performSegue(withIdentifier: "segueLeaderboards", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (sender == nil) {
            let battleViewController = segue.destination as! BattleViewController
            
            battleViewController.enemyPokemon = self.enemyPokemonCollection[selectedIndex]
            battleViewController.myPokemon = self.myPokemon
            battleViewController.documentID = self.documentID
            battleViewController.userMoney = self.userMoney
            battleViewController.numWins = self.numWins
        } else {
            
//            let leaderboardController = segue.destination as! LeaderboardTableViewController
//            leaderboardController.users = self.users
        }
        
    }

}
