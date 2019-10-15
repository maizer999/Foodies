//
//  YourLocationViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/5/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
import Alamofire
import SwiftyJSON
import KRProgressHUD
import GooglePlacesSearchController

class YourLocationViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    var center:CLLocationCoordinate2D! = nil
    var placesClient: GMSPlacesClient!
    var location:String! = nil
    let defaults = UserDefaults.standard
    var controller: GooglePlacesSearchController!
    
    var current:String! = ""
    var cLat:String! = ""
    var cLon:String! = ""
    
    
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var txt_location: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        
        txt_location.text =  defaults.string(forKey: "location")!
       // UserDefaults.standard.set("", forKey:"place")
         placesClient = GMSPlacesClient.shared()
        UserDefaults.standard.set("NO", forKey:"isLogin")
        innerView.layer.borderWidth = 1
        innerView.layer.borderColor = UIColor.init(red:221/255.0, green:221/255.0, blue:221/255.0, alpha: 1.0).cgColor
        innerView.layer.masksToBounds = true
        innerView.layer.cornerRadius = 3
        //self.defaults.set("South Cambie, Vancouver, BC, Canada", forKey: "location")
        current = "Kalma Chowk,Lahore Pakistan"
        cLat = "31.5043031"
        cLon = "74.3293853"
        defaults.set("Kalma Chowk,Lahore Pakistan", forKey:"loctionString")
      
        controller = GooglePlacesSearchController(
            apiKey: "AIzaSyD58wJosziCE_6DUYLgr2QpUCQm6J4EYUY",
            placeType: PlaceType.address
        )
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(StaticData.singleton.locationSelected == "NO"){
        determineMyCurrentLocation()
        }else if(StaticData.singleton.locationSelected == "YES"){
           
            self.txt_location.text = defaults.string(forKey: "location")
             defaults.set(self.txt_location.text,forKey:"loctionString")
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
       
            // use the feature only available in iOS 9
            // for ex. UIStackView
        locationManager.requestWhenInUseAuthorization()
      
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                StaticData.singleton.pre_location = "Kalma Chowk,Lahore Pakistan"
                current = "Kalma Chowk,Lahore Pakistan"
                cLat = "31.5043031"
                cLon = "74.3293853"
                defaults.set(self.cLat, forKey: "hostel_lat")
                defaults.set(self.cLon, forKey: "hostel_lon")
                self.txt_location.text = "Kalma Chowk,Lahore Pakistan"
                self.defaults.set("Kalma Chowk,Lahore Pakistan", forKey: "location")
                defaults.set("Kalma Chowk,Lahore Pakistan", forKey:"loctionString")
                locationManager.startUpdatingLocation()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            case .authorizedAlways:
                 locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            print("location")
        }
        
        
    }
    
    @objc func appWillEnterForeground() {
        self.determineMyCurrentLocation()
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        StaticData.singleton.center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let location = CLLocation(latitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)
        
        
        fetchCountryAndCity(location: location) { country, city in
            print("country:", country)
            print("city:", city)
            self.current = city+" "+country
            self.defaults.set(city+" "+country, forKey:"loctionString")
            self.cLat = String(userLocation.coordinate.latitude)
            self.cLon = String(userLocation.coordinate.longitude)
            self.defaults.set(self.cLat, forKey: "hostel_lat")
            self.defaults.set(self.cLon, forKey: "hostel_lon")
            self.defaults.set(city+" "+country, forKey: "location")
            self.txt_location.text = city+" "+country
            
            
        }
        manager.stopUpdatingLocation()
        
        
    }
    
    
    @IBAction func PickLocation(_ sender: Any) {
        
        StaticData.singleton.isLocation = "YES"
        print(defaults.string(forKey:"hostel_lat")!)
        let LoginVC:GetMapLocationViewController =  (storyboard!.instantiateViewController(withIdentifier: "GetMapLocationViewController") as? GetMapLocationViewController)!
        LoginVC.Current_location = self.txt_location.text
        LoginVC.Current_lat = defaults.string(forKey:"hostel_lat")
        LoginVC.Current_lon = defaults.string(forKey:"hostel_lon")
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromBottom
//        view.window!.layer.add(transition, forKey: kCATransition)
       self.present(LoginVC, animated:true, completion: nil)
        
//        let defaults = UserDefaults.standard
//
//        controller.didSelectGooglePlace { (place) -> Void in
//            print(place.description)
//            self.controller.isActive = false
//            if(defaults.string(forKey:"keystring") == ""){
//                defaults.set(place.name, forKey: "location")
//                defaults.set(String(place.coordinate.latitude), forKey: "hostel_lat")
//                defaults.set(String(place.coordinate.longitude), forKey: "hostel_lon")
//                self.txt_location.text = place.name
//                StaticData.singleton.hotel_lat = String(place.coordinate.latitude)
//                StaticData.singleton.hotel_lon = String(place.coordinate.longitude)
//                StaticData.singleton.pre_location = place.name
//            }else{
//
//
//                defaults.set(self.current, forKey: "location")
//                defaults.set(self.cLat, forKey: "hostel_lat")
//                defaults.set(self.cLon, forKey: "hostel_lon")
//                self.txt_location.text = self.current
//                StaticData.singleton.hotel_lat = self.cLat
//                StaticData.singleton.hotel_lon = self.cLon
//                StaticData.singleton.pre_location = self.current
//
//
//            }
        
            
            
//            
//        }
//        
//        self.controller.view.backgroundColor = UIColor.white
//        self.present(controller, animated:true, completion:nil)
        
        
        
//        if(center == nil){
//
//            center = CLLocationCoordinate2D(latitude:49.246292, longitude:-123.116226)
//        }
//
//        UINavigationBar.appearance().barTintColor = UIColor(red:190/255.0, green:44/255.0, blue:44/255.0, alpha:1.0)
//        UINavigationBar.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().titleTextAttributes =
//            [NSAttributedStringKey.foregroundColor: UIColor.white,
//             NSAttributedStringKey.font: UIFont(name: "Verdana", size: 15)!]
//
//        let yourBackImage = UIImage(named: "BACK")
//        UINavigationBar.appearance().backIndicatorImage = yourBackImage
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = yourBackImage
//        UINavigationBar.appearance().backItem?.title = ""
//
//        let northEast = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
//        let southWest = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
//        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
//        let config = GMSPlacePickerConfig(viewport: viewport)
//        let placePicker = GMSPlacePicker(config: config)
//
//        placePicker.pickPlace(callback: {(place, error) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//
//            if let place = place {
//
//                print(place.formattedAddress)
//
//
//                let defaults = UserDefaults.standard
//
//
//                defaults.set(place.name, forKey: "location")
//                defaults.set(String(place.coordinate.latitude), forKey: "hostel_lat")
//                defaults.set(String(place.coordinate.longitude), forKey: "hostel_lon")
//                self.txt_location.text = place.name
//                StaticData.singleton.hotel_lat = String(place.coordinate.latitude)
//                StaticData.singleton.hotel_lon = String(place.coordinate.longitude)
//                StaticData.singleton.pre_location = place.name
//
//               // self.txtPick.setTitle(place.name, for: .normal)
//
//
//            } else {
//
//            }
//        })
//
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func LocationModule(){
        
        let alertController = UIAlertController(title:"Warning!", message:"Please go to settings to on your current location.", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
           UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        })
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(alertAction)
        alertController.addAction(alertAction1)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func showLocation(_ sender: Any) {
        
        
        if(txt_location.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Location.")
        }else{
            
            self.performSegue(withIdentifier:"showLocation", sender:self)
        }
    }
    
    


}
