//
//  AddAddressPresent.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/18/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
import GooglePlacesSearchController

class AddAddressPresent: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationManager:CLLocationManager!
    
    var placesClient: GMSPlacesClient!
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var txt_location: UITextField!
    
    var controller: GooglePlacesSearchController!
    
    @IBOutlet weak var txt_huoseNo: UITextField!
    
    var cCountry:String! = ""
   
    @IBOutlet weak var txt_city: UITextField!
    

    
     let defaults = UserDefaults.standard
    
    @IBOutlet weak var txt_instruction: UITextField!
  
    var current:String! = ""
    var cLat:String! = ""
    var cLon:String! = ""
    var codeTitle:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("", forKey:"Country")
        txt_city.isUserInteractionEnabled = false
       
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        current = "Kalma Chowk,Lahore Pakistan"
        cLat = "31.5043031"
        cLon = "74.3293853"
       
        controller = GooglePlacesSearchController(
            apiKey: "AIzaSyD58wJosziCE_6DUYLgr2QpUCQm6J4EYUY",
            placeType: PlaceType.address
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         //determineMyCurrentLocation()
        
        if(StaticData.singleton.locationSelected == "NO"){
            
        }else if(StaticData.singleton.locationSelected == "YES"){
            
            self.cCountry = defaults.string(forKey: "addCountry")
            
            StaticData.singleton.center1 =  defaults.string(forKey: "add_lat")
            StaticData.singleton.center2 =  defaults.string(forKey: "add_lon")
            if(StaticData.singleton.center1  == ""){
                
                self.txt_location.text = ""
            }else{
                let location = CLLocation(latitude:Double(StaticData.singleton.center1)!, longitude:Double(StaticData.singleton.center2)!)
                fetchCountryAndCity(location: location) { country, city in
                    print("country:", country)
                    print("city:", city)
                    self.current = city+" "+country
                    
                    self.cLat = String(StaticData.singleton.center1)
                    self.cLon = String(StaticData.singleton.center2)
                    StaticData.singleton.center1 = self.cLat
                    StaticData.singleton.center2 = self.cLon
                    self.cCountry = country
                    self.txt_city.text = city
                    self.defaults.set(StaticData.singleton.center1, forKey: "hostel_lat")
                    self.defaults.set(StaticData.singleton.center2, forKey: "hostel_lon")
                    //self.defaults.set(city+" "+country, forKey:"loctionString")
                    
                }
                self.txt_location.text = StaticData.singleton.center1+","+StaticData.singleton.center2
            }
        }
        
        
        defaults.set("", forKey: "addCountry")
        defaults.set("", forKey: "add_lat")
        defaults.set("", forKey: "add_lon")
        
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
      
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                current = "Kalma Chowk,Lahore Pakistan"
                cLat = "31.5043031"
                cLon = "74.3293853"
                defaults.set("Kalma Chowk,Lahore Pakistan", forKey:"loctionString")
                StaticData.singleton.center1 = self.cLat
                StaticData.singleton.center2 = self.cLon
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            print("location")
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        //        StaticData.singleton.center1 = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let location = CLLocation(latitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)
        fetchCountryAndCity(location: location) { country, city in
            print("country:", country)
            print("city:", city)
            self.current = city+" "+country
            
            self.cLat = String(userLocation.coordinate.latitude)
            self.cLon = String(userLocation.coordinate.longitude)
            StaticData.singleton.center1 = self.cLat
            StaticData.singleton.center2 = self.cLon
            self.cCountry = country
            self.defaults.set(city+" "+country, forKey:"loctionString")
            
        }
        manager.stopUpdatingLocation()
        
        
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
    
 
    @IBAction func openGooglemap(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        
        
        StaticData.singleton.isLocation = "NO"
        
        let LoginVC:GetMapLocationViewController =  (storyboard!.instantiateViewController(withIdentifier: "GetMapLocationViewController") as? GetMapLocationViewController)!
        LoginVC.Current_location = defaults.string(forKey:"location")
        LoginVC.Current_lat = defaults.string(forKey:"hostel_lat")
        LoginVC.Current_lon = defaults.string(forKey:"hostel_lon")
        
        self.present(LoginVC, animated:true, completion: nil)
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        if(txt_huoseNo.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your house number.")
        }else if(txt_city.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your city.")
        }else if(txt_location.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter location.")
        }
        else{
            
            self.addAddressApi()
        }
        
    }
    
    func addAddressApi(){
        
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.addDeliveryAddress
        if(txt_instruction.text == nil){
            
            txt_instruction.text = ""
        }
        
        let parameter :[String:Any]? = ["street":txt_huoseNo.text!,"apartment":"","city":txt_city.text!,"state":"","country":self.cCountry,"user_id":UserDefaults.standard.string(forKey: "uid")!,"default":"1","zip":"","instruction":txt_instruction.text!,"lat":StaticData.singleton.center1,"long":StaticData.singleton.center2]
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                self.self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                self.codeTitle = String(describing: code)
                if(String(describing: code) == "200"){
                    
                    
                   // self.alertModule(title:"Success",msg:"Address added successfully")
                    
                    self.dismiss(animated: true, completion:nil)
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    func LocationModule(){
        
        let alertController = UIAlertController(title:"Warning!", message:"Please go to settings to on your current location.", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction!) in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        })
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(alertAction)
        alertController.addAction(alertAction1)
      
        present(alertController, animated: true, completion: nil)
        
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            if title == "Success" {
                
                
            }
        })
        
        alertController.addAction(alertAction)
       
        present(alertController, animated: true, completion: nil)
        
    }
    
}
