//
//  TrackLocationViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/5/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import KRProgressHUD
import CoreLocation
import ImageSlideshow
import FirebaseAuth
import FirebaseDatabase

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
};extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
class TrackLocationViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UIScrollViewDelegate {
   
    @IBOutlet weak var pagerControl: UIPageControl!
    
    @IBOutlet weak var mapView: GMSMapView!
   
    
    var scroll: UIScrollView!
    var status:String! = "1"
    
    @IBOutlet weak var innerView: UIView!
    
    
    var locationManager:CLLocationManager!
    var polyArray = [GMSPolyline]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var tDict:Riderorder?
    
    var riderMarker: GMSMarker!
    
    var mLat:String = ""
    var count:Int! = 0
    var mLon:String = ""
    var riderlat:String! = "0.0"
    var riderlong:String! = "0.0"
    var userlat:String! = "0.0"
    var userlong:String! = "0.0"
    var hotellat:String! = "0.0"
    var hotellong:String! = "0.0"
    var preriderlat:String! = "0.0"
    var preriderlong:String! = "0.0"
    var change:String! = "1"
    //var socketId:String! = ""

    
 
    let childTrack2 = FIRDatabase.database().reference().child("tracking_status").child(StaticData.singleton.OrderId!)
    
var timer = Timer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        change = "1"
        
        self.childTrack2.observe(FIRDataEventType.value, with: { (snapshot) in
            
            let firebaseDic = snapshot.value as? [String: AnyObject]
            if(firebaseDic != nil){
            print(firebaseDic!)
            
            let mapChange = firebaseDic!["map_change"] as! String
           
            if(self.change == "0"){
                if(mapChange == "1"){
                self.PathApi()
            }else{
                
                self.PathApi2()
            }
        }
            
        }
        })
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(applicationWillTerminate),
//                                               name: NSNotification.Name.UIApplicationWillTerminate,
//                                               object: nil)
        
        status = "1"
        
       pagerControl.tag = 1000
//        self.scroll = UIScrollView(frame: CGRect(x: 2, y:2, width:self.innerView.frame.size.width, height:self.innerView.frame.size.height-self.pagerControl.frame.size.height))
//        self.innerView.addSubview(self.scroll)
//        scroll.showsHorizontalScrollIndicator = false
        
        self.mapView.delegate = self
        
        //rider_name.text = StaticData.singleton.map_name
       // rider_phone.text = StaticData.singleton.map_phone
        //self.innerview.layer.borderWidth = 1
        innerView.layer.masksToBounds = false
        innerView.layer.cornerRadius = 5.0
        innerView.clipsToBounds = true
    
        self.innerView.layer.borderWidth = 1
        self.innerView.layer.borderColor = UIColor(red:161/255, green:161/255, blue:161/255, alpha: 1).cgColor
        //self.innerview.layer.borderColor = UIColor.init(red:235/255.0, green:235/255.0, blue:235/255.0, alpha: 1.0).cgColor
        
        self.PathApi()
        
       
       
        

            
 
    }


    @objc func applicationWillTerminate() {
       
    }
 
 
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        innerView.layer.masksToBounds = false
        innerView.layer.shadowColor = color.cgColor
        innerView.layer.shadowOpacity = opacity
        innerView.layer.shadowOffset = offSet
        innerView.layer.shadowRadius = radius
        
        innerView.layer.shadowPath = UIBezierPath(rect: self.innerView.bounds).cgPath
        innerView.layer.shouldRasterize = true
        innerView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree
        }
        else {
            return 360 + degree
        }
    }
   

    
    override func viewWillAppear(_ animated: Bool) {
     NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification1(notification:)), name: Notification.Name("NotificationIdentifier2"), object: nil)
    }
    
    @objc func methodOfReceivedNotification1(notification: Notification){
       
        self.PathApi()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if #available(iOS 11.0, *) {
            locationManager.requestAlwaysAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        mLat = String(userLocation.coordinate.latitude)
        mLon = String(userLocation.coordinate.longitude)
        
        StaticData.singleton.center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        manager.stopUpdatingLocation()
        
        
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        print(self.count)
        self.pagerControl.numberOfPages = self.count
        //self.pagerControl.currentPage = 0
      
        
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
  
    @IBAction func changepage(_ sender: Any) {
        let x = CGFloat(pagerControl.currentPage) * scroll.frame.size.width
        scroll.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pagerControl.currentPage = Int(pageNumber)
    }
    
    func PathApi(){
        
//
//        appDelegate.showActivityIndicatory(uiView:self.view)
//
//        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let url : String = appDelegate.baseUrl+appDelegate.showRiderLocationAgainstOrder
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"order_id":StaticData.singleton.OrderId!,"map_change":self.change]
        
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
//                self.view.isUserInteractionEnabled = true
//                KRProgressHUD.dismiss {
//                    print("dismiss() completion handler.")
//                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    self.change = "0"
                    let myCountry = dic["msg"] as? [[String:Any]]
                    
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        var map_change:String! = "0"
                        
                        let order1 = Dict["RiderOrder"] as! [String:Any]
                        let order2 = order1["RiderLocation"] as! NSDictionary
                        print(order2)
                        let order3 = Dict["UserLocation"] as! NSDictionary
                        let order4 = Dict["RestaurantLocation"] as! NSDictionary
                        let order5 = Dict["Rider"] as! NSDictionary
                        let first = order5["first_name"] as? String
                        let last = order5["last_name"] as? String
                        let phone = order5["phone"] as? String
                        
                        if(first == "" || last == "" ){
                             StaticData.singleton.map_name = ""
                        }else{
                            
                            StaticData.singleton.map_name = first!+" "+last!
                        }
                        if(phone == "" ){
                            StaticData.singleton.map_phone = ""
                        }else{
                            
                            StaticData.singleton.map_phone = phone
                        }
                        
                      
                        
                        print(order2)
                        print(order3)
                        print(order4)
                        self.riderlat = order2["lat"] as? String
                        self.riderlong = order2["long"] as? String
                        self.userlat = order3["lat"] as? String
                        self.userlong = order3["long"] as? String
                        self.hotellat = order4["lat"] as? String
                        self.hotellong = order4["long"] as? String
                        
                        var statusString = ""
                        if let status = order2["status"] as? NSArray {
                            var xOffset:Int! = 0
                            self.count = 0
                            
                            
                            let dic = status[0] as? NSDictionary
                            statusString = (dic!["order_status"] as? String)!
                            map_change = (dic!["map_change"] as? String)!
                            let subViews = self.innerView.subviews
                            for subview in subViews{
                                if(subview.tag == 1000){
                                    
                                }else{
                                    subview.removeFromSuperview()
                                }
                            }
                            self.scroll = UIScrollView(frame: CGRect(x: 2, y:2, width:self.innerView.frame.size.width, height:self.innerView.frame.size.height-self.pagerControl.frame.size.height))
                            self.scroll.alwaysBounceVertical = false
                            self.scroll.alwaysBounceHorizontal = false
                            self.innerView.backgroundColor = UIColor.white
                            self.scroll.delegate = self
                            self.scroll.showsHorizontalScrollIndicator = false
                            self.scroll.isPagingEnabled = true
                            self.scroll.contentSize = CGSize(width:self.scroll.frame.size.width*CGFloat(status.count),height:1.0)
                            
                            self.innerView.addSubview(self.scroll)
                            for i in 0...status.count-1{
                                let dic = status[i] as? NSDictionary
                                self.count =  self.count+1
                                
                                let myView:UIView! =  UIView(frame: CGRect(x:((self.scroll.frame.size.width)*CGFloat(i))+20,y:0,width:self.scroll.frame.size.width-20,height:self.scroll.frame.size.height))
                                let headerLabel2 = UILabel(frame: CGRect(x:0, y:5, width:
                                    myView.frame.size.width-20, height: myView.frame.size.height))
                                headerLabel2.text = dic!["order_status"] as? String
                                headerLabel2.font  = UIFont (name: "Verdana", size:15)
                                headerLabel2.textAlignment = .center
                                headerLabel2.lineBreakMode = .byWordWrapping
                                headerLabel2.numberOfLines = 0
                                headerLabel2.adjustsFontSizeToFitWidth = true
                                myView.addSubview(headerLabel2)
                                self.scroll.addSubview(myView)
                                //xOffset = xOffset+Int(myView.frame.size.width)
                            }
                            self.configurePageControl()
//
                        }
                        
                        var contentRect = CGRect.zero
                        
                        for view in self.scroll.subviews {
                            contentRect = contentRect.union(view.frame)
                        }
                        self.scroll.contentSize = contentRect.size
                       
                        if(self.riderlat == "" && self.userlat == ""){
                            self.mapView.camera = GMSCameraPosition.camera(withLatitude: (self.hotellat as NSString).doubleValue, longitude: (self.hotellong! as NSString).doubleValue, zoom: 15.0)
                            let position = CLLocationCoordinate2D(latitude:(self.hotellat as NSString).doubleValue, longitude: (self.hotellong as NSString).doubleValue)
                            
                            let marker = GMSMarker(position: position)
                            
                            marker.icon = UIImage(named: "HotelPin")
                            //marker.title = "Customer have selected same location as yours"
                            marker.map = self.mapView
                        
                        }else if(self.userlat == ""){
                            if(map_change == "1"){
                                let childTrack = FIRDatabase.database().reference().child("tracking").child((order5["user_id"] as? String)!)
                            self.riderMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(self.riderlat)!, longitude: Double(self.riderlong)!))
                            self.riderMarker.icon = UIImage(named:"Car.png")
                            self.riderMarker.map = self.mapView
                            childTrack.observe(FIRDataEventType.value, with: { (snapshot) in
                                
                                let firebaseDic = snapshot.value as? [String: AnyObject]
                                if(firebaseDic != nil){
                                print(firebaseDic!)
                                
                                self.riderlat = firebaseDic!["rider_lat"] as! String
                                self.riderlong = firebaseDic!["rider_long"] as! String
                                self.preriderlat = firebaseDic!["rider_previous_lat"] as! String
                                self.preriderlong = firebaseDic!["rider_previous_long"] as! String
                                if(self.riderlat == "" || self.preriderlat == ""){
                                    
                                }else{
                                    
                                    self.makePath3()
//                                    self.riderMarker.position = CLLocationCoordinate2D(latitude: (self.riderlat as NSString).doubleValue, longitude: (self.riderlong as NSString).doubleValue)
//                                    self.mapView.camera = GMSCameraPosition.camera(withTarget: self.riderMarker.position, zoom: 15.0)
                                    let oldCoodinate =  CLLocationCoordinate2D(latitude:Double(self.preriderlat)!, longitude: Double(self.preriderlong)!)
                                    let newCoodinate = CLLocationCoordinate2D(latitude:Double(self.riderlat)!, longitude: Double(self.riderlong)!)
                                    self.riderMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                                    self.riderMarker.rotation = CLLocationDegrees(self.getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
                                    //found bearing value by calculation when marker add
                                    self.riderMarker.position = oldCoodinate
                                    //this can be old position to make car movement to new position
                                    self.riderMarker.map = self.mapView
                                    //marker movement animation
                                    CATransaction.begin()
                                    CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
                                    CATransaction.setCompletionBlock({() -> Void in
                                        self.riderMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))

                                        self.riderMarker.rotation = CLLocationDegrees(self.getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
                                        //New bearing value from backend after car movement is done
                                    })
                                    self.riderMarker.position = newCoodinate
                                    //this can be new position after car moved from old position to new position with animation
                                    self.riderMarker.map = self.mapView
                                    self.riderMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                                    self.riderMarker.rotation = CLLocationDegrees(self.getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
                                    //found bearing value by calculation
                                    CATransaction.commit()
                               }
                            }
                                
                            })
                            self.makePath()
                            
                            }
                        }else if(self.hotellat == ""){
                            if(map_change == "1"){
                                 let childTrack = FIRDatabase.database().reference().child("tracking").child((order5["user_id"] as? String)!)
                            self.riderMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(self.riderlat)!, longitude: Double(self.riderlong)!))
                            self.riderMarker.icon = UIImage(named:"Car.png")
                            self.riderMarker.map = self.mapView
                            childTrack.observe(FIRDataEventType.value, with: { (snapshot) in
                                
                                let firebaseDic = snapshot.value as? [String: AnyObject]
                                 if(firebaseDic != nil){
                                print(firebaseDic!)
                                
                                self.riderlat = firebaseDic!["rider_lat"] as! String
                                self.riderlong = firebaseDic!["rider_long"] as! String
                                self.preriderlat = firebaseDic!["rider_previous_lat"] as! String
                                self.preriderlong = firebaseDic!["rider_previous_long"] as! String
                                if(self.riderlat == "" || self.preriderlat == ""){
                                    
                                }else{
                                    
                                    self.makePath2()
                                   
                                    let oldCoodinate =  CLLocationCoordinate2D(latitude:Double(self.preriderlat)!, longitude: Double(self.preriderlong)!)
                                    let newCoodinate = CLLocationCoordinate2D(latitude:Double(self.riderlat)!, longitude: Double(self.riderlong)!)
                                    self.riderMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                                    self.riderMarker.rotation = CLLocationDegrees(self.getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
                                    //found bearing value by calculation when marker add
                                    self.riderMarker.position = oldCoodinate
                                    //this can be old position to make car movement to new position
                                    self.riderMarker.map = self.mapView
                                    //marker movement animation
                                    CATransaction.begin()
                                    CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
                                    CATransaction.setCompletionBlock({() -> Void in
                                        self.riderMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))

                                        self.riderMarker.rotation = CLLocationDegrees(self.getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
                                        //New bearing value from backend after car movement is done
                                    })
                                    self.riderMarker.position = newCoodinate
                                    //this can be new position after car moved from old position to new position with animation
                                    self.riderMarker.map = self.mapView
                                    self.riderMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                                    self.riderMarker.rotation = CLLocationDegrees(self.getHeadingForDirection(fromCoordinate: oldCoodinate, toCoordinate: newCoodinate))
                                    //found bearing value by calculation
                                    CATransaction.commit()
                                }
                                }
                            })
                            self.makePath1()
                            }
                        }
                       
                        
                        
                        
                        
                       

                    }
                    
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
//                self.view.isUserInteractionEnabled = true
//                KRProgressHUD.dismiss {
//                    print("dismiss() completion handler.")
//                }
                print(error)
                self.PathApi()
                //self.alertModule(title:"Error", msg:error.localizedDescription)
                
                
            }
        })
        
    }
    func PathApi2(){
        
        //
        //        appDelegate.showActivityIndicatory(uiView:self.view)
        //
        //        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        self.change = "0"
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.showRiderLocationAgainstOrder
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"order_id":StaticData.singleton.OrderId!,"map_change":self.change]
        
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                //                self.view.isUserInteractionEnabled = true
                //                KRProgressHUD.dismiss {
                //                    print("dismiss() completion handler.")
                //                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    self.change = "0"
                    let myCountry = dic["msg"] as? [[String:Any]]
                    
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        var map_change:String! = "0"
                        
                        let order1 = Dict["RiderOrder"] as! [String:Any]
                        let order2 = order1["RiderLocation"] as! NSDictionary
                        print(order2)
                        let order3 = Dict["UserLocation"] as! NSDictionary
                        let order4 = Dict["RestaurantLocation"] as! NSDictionary
                        let order5 = Dict["Rider"] as! NSDictionary
                        let first = order5["first_name"] as? String
                        let last = order5["last_name"] as? String
                        let phone = order5["phone"] as? String
                        
                        if(first == "" || last == "" ){
                            StaticData.singleton.map_name = ""
                        }else{
                            
                            StaticData.singleton.map_name = first!+" "+last!
                        }
                        if(phone == "" ){
                            StaticData.singleton.map_phone = ""
                        }else{
                            
                            StaticData.singleton.map_phone = phone
                        }
                        
                        
                        
                        print(order2)
                        print(order3)
                        print(order4)
                        self.riderlat = order2["lat"] as? String
                        self.riderlong = order2["long"] as? String
                        self.userlat = order3["lat"] as? String
                        self.userlong = order3["long"] as? String
                        self.hotellat = order4["lat"] as? String
                        self.hotellong = order4["long"] as? String
                        
                        var statusString = ""
                        if let status = order2["status"] as? NSArray {
                            var xOffset:Int! = 0
                            self.count = 0
                            
                            
                            let dic = status[0] as? NSDictionary
                            statusString = (dic!["order_status"] as? String)!
                            map_change = (dic!["map_change"] as? String)!
                            let subViews = self.innerView.subviews
                            for subview in subViews{
                                if(subview.tag == 1000){
                                    
                                }else{
                                    subview.removeFromSuperview()
                                }
                            }
                            self.scroll = UIScrollView(frame: CGRect(x: 2, y:2, width:self.innerView.frame.size.width, height:self.innerView.frame.size.height-self.pagerControl.frame.size.height))
                            self.scroll.alwaysBounceVertical = false
                            self.scroll.alwaysBounceHorizontal = false
                            self.innerView.backgroundColor = UIColor.white
                            self.scroll.delegate = self
                            self.scroll.showsHorizontalScrollIndicator = false
                            self.scroll.isPagingEnabled = true
                            self.scroll.contentSize = CGSize(width:self.scroll.frame.size.width*CGFloat(status.count),height:1.0)
                            
                            self.innerView.addSubview(self.scroll)
                            for i in 0...status.count-1{
                                let dic = status[i] as? NSDictionary
                                self.count =  self.count+1
                                
                                let myView:UIView! =  UIView(frame: CGRect(x:((self.scroll.frame.size.width)*CGFloat(i))+20,y:0,width:self.scroll.frame.size.width-20,height:self.scroll.frame.size.height))
                                let headerLabel2 = UILabel(frame: CGRect(x:0, y:5, width:
                                    myView.frame.size.width, height: myView.frame.size.height))
                                headerLabel2.text = dic!["order_status"] as? String
                                headerLabel2.font  = UIFont (name: "Verdana", size:15)
                                headerLabel2.textAlignment = .center
                                headerLabel2.lineBreakMode = .byWordWrapping
                                headerLabel2.numberOfLines = 0
                                headerLabel2.adjustsFontSizeToFitWidth = true
                                myView.addSubview(headerLabel2)
                                self.scroll.addSubview(myView)
                                //xOffset = xOffset+Int(myView.frame.size.width)
                            }
                            self.configurePageControl()
                            //
                        }
                        
                        var contentRect = CGRect.zero
                        
                        for view in self.scroll.subviews {
                            contentRect = contentRect.union(view.frame)
                        }
                        self.scroll.contentSize = contentRect.size
                      
                        
                    }
                   
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
                //                self.view.isUserInteractionEnabled = true
                //                KRProgressHUD.dismiss {
                //                    print("dismiss() completion handler.")
                //                }
                print(error)
                self.PathApi2()
                //self.alertModule(title:"Error", msg:error.localizedDescription)
                
                
            }
        })
        
    }
   
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func makePath1(){
        self.mapView.clear()
        //        var bounds = GMSCoordinateBounds()
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: (self.userlat as NSString).doubleValue, longitude: (self.userlong! as NSString).doubleValue, zoom: 1.0)
        self.riderMarker.title = StaticData.singleton.map_name
        self.riderMarker.snippet = StaticData.singleton.map_phone
        print(self.riderlat)
        print(self.riderlong)
        print(self.userlat)
        print(self.userlong)
        let str :String?
        if(self.riderlat == nil ||  self.riderlat == nil || self.userlat == nil || self.userlong == nil){
            
            str = ""
            
        }else{
            
            str = String(format:"https://maps.googleapis.com/maps/api/directions/json?origin=\(self.riderlat!),\(self.riderlong!)&destination=\(self.userlat!),\(self.userlong!)&key=AIzaSyDTLC9W4aT03w1doMhWPdlelSbfnlr1w6o")
            
            print(str!)
            
            
        }
        
        
        
        
        Alamofire.request(str!).responseJSON { (responseObject) -> Void in
            
            let resJson = JSON(responseObject.result.value)
            print(resJson)
            
            if(resJson["status"].rawString()! == "ZERO_RESULTS")
            {
                
            }
            else if(resJson["status"].rawString()! == "NOT_FOUND")
            {
                
            }
      
            else{
                
              if  let routes : NSArray = resJson["routes"].rawValue as? NSArray{
                print(routes)
                
                
                
                // mapView.isMyLocationEnabled = true
                let position = CLLocationCoordinate2D(latitude:(self.userlat as NSString).doubleValue, longitude: (self.userlong as NSString).doubleValue)
                
                let marker = GMSMarker(position: position)
                
                marker.icon = UIImage(named: "House")
                //marker.title = "Customer have selected same location as yours"
                marker.map = self.mapView
                //bounds = bounds.includingCoordinate(marker.position)
                
                
//                let position2 = CLLocationCoordinate2D(latitude:(self.hotellat as NSString).doubleValue, longitude: (self.hotellong as NSString).doubleValue )
//
//                let marker1 = GMSMarker(position: position2)
//                marker1.icon = UIImage(named: "HotelPin")
//                //marker1.title = self.locationAddress
//                marker1.appearAnimation = GMSMarkerAnimation.pop
//                marker1.map = self.mapView
               
                self.riderMarker.icon = UIImage(named:"Car.png")
                self.riderMarker.map = self.mapView
                //self.getAddressFromLatLon(pdblLatitude:self.riderlat, withLongitude:self.riderlong)
                
                for p in (0 ..< self.polyArray.count) {
                    (self.polyArray[p]).map = nil
                }
                let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
                print(pathv)
                let paths : NSArray = pathv.value(forKey: "points") as! NSArray
                print(paths)
                let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
                
                
                let polyLine = GMSPolyline(path: newPath)
                polyLine.strokeWidth = 5
                polyLine.strokeColor = UIColor(red:190/255.0, green:44/255.0, blue:44/255.0, alpha:1.0)
                polyLine.map = self.mapView
                self.polyArray.append(polyLine)
                let bounds = GMSCoordinateBounds(path: newPath!)
                self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                
                }
            }
        }
        
    }
    
    
    func makePath(){
       self.mapView.clear()
//        var bounds = GMSCoordinateBounds()
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: (self.riderlat as NSString).doubleValue, longitude: (self.riderlong as! NSString).doubleValue, zoom: 1.0)
        self.riderMarker.title = StaticData.singleton.map_name
        self.riderMarker.snippet = StaticData.singleton.map_phone
        let str :String?
        if(self.riderlat == "0.0" || self.riderlong == "0.0" || self.hotellat == "0.0" || self.hotellong == "0.0" ){
          
            str = ""
            
        }else{
            
            str = String(format:"https://maps.googleapis.com/maps/api/directions/json?origin=\(self.riderlat!),\(self.riderlong!)&destination=\(self.hotellat!),\(self.hotellong!)&key=AIzaSyDTLC9W4aT03w1doMhWPdlelSbfnlr1w6o")
            
            print(str!)
        }
        
        
        
        
        Alamofire.request(str!).responseJSON { (responseObject) -> Void in
            
            let resJson = JSON(responseObject.result.value)
            print(resJson)
            
            if(resJson["status"].rawString()! == "ZERO_RESULTS")
            {
                
            }
            else if(resJson["status"].rawString()! == "NOT_FOUND")
            {
                
            }
            else{
                
                if  let routes : NSArray = resJson["routes"].rawValue as? NSArray{
                print(routes)
                
                
                
               // mapView.isMyLocationEnabled = true
                let position = CLLocationCoordinate2D(latitude:(self.riderlat as NSString).doubleValue, longitude: (self.riderlong as NSString).doubleValue)
                
                let marker = GMSMarker(position: position)
                
               // marker.icon = UIImage(named: "Car.png")
                //marker.title = "Customer have selected same location as yours"
                //marker.map = self.mapView
                //bounds = bounds.includingCoordinate(marker.position)
                
                
                let position2 = CLLocationCoordinate2D(latitude:(self.hotellat as NSString).doubleValue, longitude: (self.hotellong as NSString).doubleValue )
                
                let marker1 = GMSMarker(position: position2)
                marker1.icon = UIImage(named: "HotelPin")
                //marker1.title = self.locationAddress
                marker1.appearAnimation = GMSMarkerAnimation.pop
                marker1.map = self.mapView
                self.riderMarker.icon = UIImage(named:"Car.png")
                self.riderMarker.map = self.mapView
                //self.getAddressFromLatLon(pdblLatitude:StaticData.singleton.rider_lat!, withLongitude:StaticData.singleton.rider_lon!)
                
                    for p in (0 ..< self.polyArray.count) {
                        (self.polyArray[p]).map = nil
                    }
                let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
                print(pathv)
                let paths : NSArray = pathv.value(forKey: "points") as! NSArray
                print(paths)
                let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
                
                
                let polyLine = GMSPolyline(path: newPath)
                polyLine.strokeWidth = 5
                polyLine.strokeColor = UIColor(red:190/255.0, green:44/255.0, blue:44/255.0, alpha:1.0)
                self.polyArray.append(polyLine)
                polyLine.map = self.mapView
                self.polyArray.append(polyLine)
                let bounds = GMSCoordinateBounds(path: newPath!)
                self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                }
                
            }
        }
        
    }
    func makePath2(){
      
        //        var bounds = GMSCoordinateBounds()
        
        self.riderMarker.title = StaticData.singleton.map_name
        self.riderMarker.snippet = StaticData.singleton.map_phone
        print(self.riderlat)
        print(self.riderlong)
        print(self.userlat)
        print(self.userlong)
        let str :String?
        if(self.riderlat == nil ||  self.riderlat == nil || self.userlat == nil || self.userlong == nil){
            
            str = ""
            
        }else{
            
            str = String(format:"https://maps.googleapis.com/maps/api/directions/json?origin=\(self.riderlat!),\(self.riderlong!)&destination=\(self.userlat!),\(self.userlong!)&key=AIzaSyDTLC9W4aT03w1doMhWPdlelSbfnlr1w6o")
            
            print(str!)
            
            
        }
        
        
        
        
        Alamofire.request(str!).responseJSON { (responseObject) -> Void in
            
            let resJson = JSON(responseObject.result.value)
            print(resJson)
            
            if(resJson["status"].rawString()! == "ZERO_RESULTS")
            {
                
            }
            else if(resJson["status"].rawString()! == "NOT_FOUND")
            {
                
            }
                
            else{
                
                if  let routes : NSArray = resJson["routes"].rawValue as? NSArray{
                    print(routes)
               
                    //self.getAddressFromLatLon(pdblLatitude:self.riderlat, withLongitude:self.riderlong)
                    
                    for p in (0 ..< self.polyArray.count) {
                        (self.polyArray[p]).map = nil
                    }
                    let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
                    print(pathv)
                    let paths : NSArray = pathv.value(forKey: "points") as! NSArray
                    print(paths)
                    let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
                    
                    
                    let polyLine = GMSPolyline(path: newPath)
                    polyLine.strokeWidth = 5
                    polyLine.strokeColor = UIColor(red:190/255.0, green:44/255.0, blue:44/255.0, alpha:1.0)
                    polyLine.map = self.mapView
                    self.polyArray.append(polyLine)
                    //let bounds = GMSCoordinateBounds(path: newPath!)
                    //self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                    
                }
            }
        }
        
    }
    
    
    func makePath3(){
       
        //        var bounds = GMSCoordinateBounds()
    
        self.riderMarker.title = StaticData.singleton.map_name
        self.riderMarker.snippet = StaticData.singleton.map_phone
        let str :String?
        if(self.riderlat == "0.0" || self.riderlong == "0.0" || self.hotellat == "0.0" || self.hotellong == "0.0" ){
            
            str = ""
            
        }else{
            
            str = String(format:"https://maps.googleapis.com/maps/api/directions/json?origin=\(self.riderlat!),\(self.riderlong!)&destination=\(self.hotellat!),\(self.hotellong!)&key=AIzaSyDTLC9W4aT03w1doMhWPdlelSbfnlr1w6o")
            
            print(str!)
        }
        
        
        
        
        Alamofire.request(str!).responseJSON { (responseObject) -> Void in
            
            let resJson = JSON(responseObject.result.value)
            print(resJson)
            
            if(resJson["status"].rawString()! == "ZERO_RESULTS")
            {
                
            }
            else if(resJson["status"].rawString()! == "NOT_FOUND")
            {
                
            }
            else{
                
                if  let routes : NSArray = resJson["routes"].rawValue as? NSArray{
                    print(routes)
                 
                    //self.getAddressFromLatLon(pdblLatitude:StaticData.singleton.rider_lat!, withLongitude:StaticData.singleton.rider_lon!)
                    
                    for p in (0 ..< self.polyArray.count) {
                        (self.polyArray[p]).map = nil
                    }
                    let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
                    print(pathv)
                    let paths : NSArray = pathv.value(forKey: "points") as! NSArray
                    print(paths)
                    let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
                    
                    
                    let polyLine = GMSPolyline(path: newPath)
                    polyLine.strokeWidth = 5
                    polyLine.strokeColor = UIColor(red:190/255.0, green:44/255.0, blue:44/255.0, alpha:1.0)
                    self.polyArray.append(polyLine)
                    polyLine.map = self.mapView
                self.polyArray.append(polyLine)
//let bounds = GMSCoordinateBounds(path: newPath!)
                    //self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                }
                
            }
        }
        
    }
    
   
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
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
                    
                   // self.rider_address.text = addressString
                }
        })
        
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
  
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
                if let phoneCallURL = URL(string: "tel://"+StaticData.singleton.map_phone!) {
        
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }
                }
        
    }
    
    @IBAction func callRider(_ sender: Any) {
        

 
    }
    

    
    
  



}
