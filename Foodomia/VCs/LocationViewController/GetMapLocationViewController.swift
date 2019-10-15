//
//  GetMapLocationViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 3/6/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import KRProgressHUD
import CoreLocation
import GooglePlacesSearchController
import GooglePlaces
import GooglePlacePicker

class GetMapLocationViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapview: GMSMapView!
    
    var Current_location:String! = ""
    var Current_lat:String! = ""
    var Current_lon:String! = ""
    var addCountry:String! = ""
    let defaults = UserDefaults.standard
    var controller: GooglePlacesSearchController!
    var locationManager:CLLocationManager!
    var isMapMove:String! = "YES"
    
    @IBOutlet weak var txt_location: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Current_lat)
        Current_location = defaults.string(forKey: "location")
        txt_location.text = defaults.string(forKey: "location")
        mapview.delegate = self
        StaticData.singleton.hotel_lat = defaults.string(forKey: "hostel_lat")
        StaticData.singleton.hotel_lon = defaults.string(forKey: "hostel_lon")
       
        self.txt_location.text = Current_location
       isMapMove = "NO"
      
        mapview.clear()
        var bounds = GMSCoordinateBounds()
        
     
                let position = CLLocationCoordinate2D(latitude:(Current_lat as NSString).doubleValue, longitude: (Current_lon as NSString).doubleValue)
                mapview.camera = GMSCameraPosition.camera(withLatitude: Double(Current_lat)!, longitude: Double(Current_lon)!, zoom:17)
        
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        circleView.backgroundColor = UIColor.clear
        let circleView1 = UIImageView(frame: CGRect(x: 0, y: 0, width:36, height:50))
        circleView1.image = UIImage(named:"Mobile-App-Screens")!
        circleView.addSubview(circleView1)
        mapview.addSubview(circleView)
        mapview.bringSubview(toFront: circleView)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        
        view.updateConstraints()
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
//            circleView.layer.cornerRadius = circleView.frame.width/2
//            circleView.clipsToBounds = true
        })
                
//                let marker = GMSMarker(position: position)
//
//                marker.icon = UIImage(named: "Mobile-App-Screens")
//                marker.isDraggable = true
//
//                marker.appearAnimation = GMSMarkerAnimation.pop
//
//                marker.map = mapview
//
//                bounds = bounds.includingCoordinate(position)
        self.determineMyCurrentLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
                self.txt_location.text = "Kalma Chowk,Lahore Pakistan"
                StaticData.singleton.hotel_lat  = "31.5043031"
                StaticData.singleton.hotel_lon = "74.3293853"
                defaults.set(StaticData.singleton.hotel_lat, forKey: "hostel_lat")
                defaults.set(StaticData.singleton.hotel_lon, forKey: "hostel_lon")
                self.txt_location.text = "Kalma Chowk,Lahore Pakistan"
                self.defaults.set("Kalma Chowk,Lahore Pakistan", forKey: "location")
                defaults.set("Kalma Chowk,Lahore Pakistan", forKey:"loctionString")
                
             
                self.mapview.camera = GMSCameraPosition.camera(withLatitude: Double(StaticData.singleton.hotel_lat!)!, longitude: Double(StaticData.singleton.hotel_lon!)!, zoom:17)
               
                
              self.addCountry = "Pakistan"
               
                
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
        
        if(Current_location == "Kalma Chowk,Lahore Pakistan"){
        fetchCountryAndCity(location: location) { country, city in
            print("country:", country)
            print("city:", city)
            
            
            StaticData.singleton.pre_location = city+" "+country
            self.defaults.set(city+" "+country, forKey:"loctionString")
            StaticData.singleton.hotel_lat = String(userLocation.coordinate.latitude)
            StaticData.singleton.hotel_lon = String(userLocation.coordinate.longitude)
            self.defaults.set(StaticData.singleton.hotel_lat, forKey: "hostel_lat")
            self.defaults.set(StaticData.singleton.hotel_lon, forKey: "hostel_lon")
            self.defaults.set(city+" "+country, forKey: "location")
            self.txt_location.text = city+" "+country
            self.mapview.camera = GMSCameraPosition.camera(withLatitude: Double(StaticData.singleton.hotel_lat!)!, longitude: Double(StaticData.singleton.hotel_lon!)!, zoom:17)
            self.addCountry = country
            
            
        }
        
        }
        manager.stopUpdatingLocation()
    }
    
    @IBAction func close(_ sender: Any) {
        
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromTop
//        view.window!.layer.add(transition, forKey: kCATransition)
        StaticData.singleton.locationSelected = ""
        self.dismiss(animated:true, completion: nil)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        let loc: CLLocation = CLLocation(latitude:Double(StaticData.singleton.hotel_lat!)!, longitude:Double(StaticData.singleton.hotel_lon!)!)
        if(isMapMove == "YES"){
            let ceo: CLGeocoder = CLGeocoder()
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }else{
                        let pm = placemarks! as [CLPlacemark]
                        
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            print(pm.country)
                            print(pm.locality)
                            print(pm.subLocality)
                            print(pm.thoroughfare)
                            print(pm.postalCode)
                            print(pm.subThoroughfare)
                            var addressString : String = ""
                            if pm.subLocality != nil {
                                addressString = addressString + pm.subLocality! + ", "
                            }
                            if pm.thoroughfare != nil {
                                addressString = addressString + pm.thoroughfare! + ", "
                            }
                            if pm.locality != nil {
                                addressString = addressString + pm.locality! + ", "
                            }
                            if pm.country != nil {
                                addressString = addressString + pm.country! + ", "
                            }
                            if pm.postalCode != nil {
                                addressString = addressString + pm.postalCode! + " "
                            }
                            
                            
                            print(addressString)
                            self.addCountry = pm.country
                            StaticData.singleton.hotel_lat = String(mapView.camera.target.latitude)
                            StaticData.singleton.hotel_lon = String(mapView.camera.target.longitude)
                            self.txt_location.text = addressString
                            
                        }
                    }
            })
        }else{
            
            self.isMapMove = "YES"
        }
        
    }


    @IBAction func searchLocation(_ sender: Any) {
        UINavigationBar.appearance().barTintColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        UINavigationBar.appearance().isTranslucent = false
        
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white,
             NSAttributedStringKey.font: UIFont(name: "Verdana", size: 15)!]
        (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]) ).defaultTextAttributes = [NSAttributedStringKey.font.rawValue: UIFont(name: "Verdana", size: 14)!, NSAttributedStringKey.foregroundColor.rawValue:UIColor.white]
        
        (UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])).attributedPlaceholder = NSAttributedString(string: "Search Location", attributes: [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "Verdana", size: 14)!, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):UIColor.white])
        UISearchBar.appearance().setImage(UIImage(named: "searchicon"), for: UISearchBarIcon.search, state:.normal)
        
    
        let center = CLLocationCoordinate2D(latitude: Double(StaticData.singleton.hotel_lat!)!, longitude: Double(StaticData.singleton.hotel_lon!)!)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            self.isMapMove = "NO"
            if let place = place {
                print(place.name)
                StaticData.singleton.hotel_lat = String(place.coordinate.latitude)
                StaticData.singleton.hotel_lon = String(place.coordinate.longitude)
                
                self.mapview.clear()
                
                //self.addCountry = place.
                
                let position = CLLocationCoordinate2D(latitude:(StaticData.singleton.hotel_lat! as NSString).doubleValue, longitude: (StaticData.singleton.hotel_lon as! NSString).doubleValue)
                let loc: CLLocation = CLLocation(latitude:(StaticData.singleton.hotel_lat! as NSString).doubleValue , longitude:(StaticData.singleton.hotel_lon! as NSString).doubleValue)
                self.mapview.camera = GMSCameraPosition.camera(withLatitude: Double(StaticData.singleton.hotel_lat!)!, longitude: Double(StaticData.singleton.hotel_lon!)!, zoom:17)
                if(!(place.name.contains("°"))){
                    StaticData.singleton.pre_location = place.name
                    self.txt_location.text = place.name
                    self.fetchCountryAndCity(location: loc) { country, city in
                        print("country:", country)
                        print("city:", city)
                        self.addCountry = country
                        
                        
                        
                    }
                   
                }else{
                
                    self.fetchCountryAndCity(location: loc) { country, city in
                        print("country:", country)
                        print("city:", city)
                        self.addCountry = country
                        StaticData.singleton.pre_location = city+" "+country
                        self.txt_location.text = city+" "+country
                        
                        
                    }
               
                
                }
                
                //self.nameLabel.text = place.name
                //self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                    //.joined(separator: "\n")
            } else {
                print(place?.name)
               // self.nameLabel.text = "No place selected"
                //self.addressLabel.text = ""
            }
        })
        
        
//        let defaults = UserDefaults.standard
//
//        controller.didSelectGooglePlace { (place) -> Void in
//            print(place.description)
//            self.controller.isActive = false
//
//            if(defaults.string(forKey:"keystring") == ""){
//
//                self.txt_location.text = place.name
//                StaticData.singleton.hotel_lat = String(place.coordinate.latitude)
//                StaticData.singleton.hotel_lon = String(place.coordinate.longitude)
//                StaticData.singleton.pre_location = place.name
//                self.mapview.clear()
//
//                self.addCountry = place.country
//
//                let position = CLLocationCoordinate2D(latitude:(StaticData.singleton.hotel_lat as! NSString).doubleValue, longitude: (StaticData.singleton.hotel_lon as! NSString).doubleValue)
//                self.mapview.camera = GMSCameraPosition.camera(withLatitude: Double(StaticData.singleton.hotel_lat!)!, longitude: Double(StaticData.singleton.hotel_lon!)!, zoom:17)
//
//
//
//            }else{
//
//                self.determineMyCurrentLocation()
//
//            }
//
//
//
//
//        }
//
//        self.controller.view.backgroundColor = UIColor.white
//            self.present(controller, animated:true, completion:nil)
    }
    
    @IBAction func save(_ sender: Any) {
        StaticData.singleton.locationSelected = "YES"
        if(StaticData.singleton.isLocation
            == "YES"){
       
        defaults.set(self.txt_location.text, forKey: "location")
        defaults.set(StaticData.singleton.hotel_lat, forKey: "hostel_lat")
        defaults.set( StaticData.singleton.hotel_lon, forKey: "hostel_lon")
           
           
        }else{
            defaults.set(self.txt_location.text, forKey: "location")
            defaults.set(self.addCountry, forKey: "addCountry")
            defaults.set(StaticData.singleton.hotel_lat, forKey: "add_lat")
            defaults.set( StaticData.singleton.hotel_lon, forKey: "add_lon")
            StaticData.singleton.isLocation = "YES"
            
        }
        self.dismiss(animated:true, completion: nil)
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
