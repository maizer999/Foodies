//
//  RestuarntsViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/25/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD
import ImageSlideshow
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import CoreLocation
import Firebase
import FirebaseDatabase
import GooglePlacesSearchController

class RestuarntsViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var myView: UIView!
    var locationManager:CLLocationManager!
    
    var placesClient: GMSPlacesClient!
    var controller: GooglePlacesSearchController!
    
    @IBOutlet var upperView: UIView!
    
    var imagesArray:NSMutableArray = []
    
    @IBOutlet weak var txt_location: UILabel!
    
    var filtered:NSMutableArray = []
    var MenuName:NSMutableArray = []
    var searchActive : Bool = false
    var current:String! = ""
    var cLat:String! = ""
    var cLon:String! = ""
    @IBOutlet weak var innerview: UIView!
    @IBOutlet weak var btn_close: UIButton!
    
    @IBOutlet weak var closeImage: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var searchbar: UITextField!
    
    var Resturantlist:NSMutableArray?
    var avglist:NSMutableArray = []
    var totalRatingslist:NSMutableArray = []
    @IBOutlet var tableview: UITableView!
    
    var loadingToggle:String? = "yes"
    var refreshControl = UIRefreshControl()
   
    let defaults = UserDefaults.standard
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        txt_location.text =  defaults.string(forKey: "location")!
       
        
        self.navigationItem.titleView = upperView
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(RestuarntsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableview?.addSubview(refreshControl)
        self.AppSliderImages()
        Resturantlist = []
        
        current = "Kalma Chowk,Lahore Pakistan"
       
        cLat = "31.5043031"
        cLon = "74.3293853"
        defaults.set("Kalma Chowk,Lahore Pakistan", forKey:"loctionString")
        
        self.getResturantsApi()
        
        controller = GooglePlacesSearchController(
            apiKey: "AIzaSyD58wJosziCE_6DUYLgr2QpUCQm6J4EYUY",
            placeType: PlaceType.address
        )
        
        
       
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc
    override func viewWillAppear(_ animated: Bool) {
        
       
        
        super.viewWillAppear(animated)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification1(notification:)), name: Notification.Name("NotificationIdentifier1"), object: nil)
       
        if(UserDefaults.standard.string(forKey:"isReview") == "Yes"){
            
            
            let loginPageView =  self.storyboard?.instantiateViewController(withIdentifier: "Account1ViewController") as! Account1ViewController
            self.present(loginPageView, animated: true, completion: nil)
        }else if(UserDefaults.standard.string(forKey:"RiderReview") == "Yes"){
            
            let loginPageView =  self.storyboard?.instantiateViewController(withIdentifier: "RiderReviewViewController") as! RiderReviewViewController
            self.present(loginPageView, animated: true, completion: nil)
        
        }
       
       
        if(StaticData.singleton.locationSelected == "NO"){
            
        }else if(StaticData.singleton.locationSelected == "YES"){
            
            txt_location.text =  defaults.string(forKey: "location")!
            defaults.set(self.txt_location.text,forKey:"loctionString")
            self.getResturantsApi()
        }
        Timer.scheduledTimer(timeInterval:7200, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        let childRef1 = FIRDatabase.database().reference().child("Cart");
        childRef1.child(UserDefaults.standard.string(forKey:"udid")!).observeSingleEvent(of:.value, with: { (snapshot) in
            
            
            if snapshot.childrenCount > 0 {
                self.tabBarController?.tabBar.items?[3].badgeValue = String(snapshot.childrenCount)
            }else{
                self.tabBarController?.tabBar.items?[3].badgeValue = nil
            }
            if(StaticData.singleton.isCartLogin == "YES"){
                StaticData.singleton.isCartLogin = "NO"
                self.tabBarController?.selectedIndex = 3
            }
            if(StaticData.singleton.isDealLogin == "YES"){
                StaticData.singleton.isDealLogin = "NO"
                self.tabBarController?.selectedIndex = 1
            }
            
            StaticData.singleton.whatsDeal = "yes"
            
            if(StaticData.singleton.isSpecitialy == "yes"){
                
                self.getfilterResturantsApi()
                
            }else{
                StaticData.singleton.isSpecitialy = "no"
                
            }
        })
 
    }
    

    
 
    @objc func update() {
  
            self.AppSliderImages()

    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        if(UserDefaults.standard.string(forKey:"isReview") == "Yes"){
            let loginPageView =  self.storyboard?.instantiateViewController(withIdentifier: "Account1ViewController") as! Account1ViewController
            self.present(loginPageView, animated: true, completion: nil)
        }
    }
    @objc func methodOfReceivedNotification1(notification: Notification){
        if(UserDefaults.standard.string(forKey:"RiderReview") == "Yes"){
            
            let loginPageView =  self.storyboard?.instantiateViewController(withIdentifier: "RiderReviewViewController") as! RiderReviewViewController
            self.present(loginPageView, animated: true, completion: nil)
            
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
       
            
            locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                StaticData.singleton.pre_location = "South Cambie, Vancouver, BC, Canada"
                current = "South Cambie, Vancouver, BC, Canada"
                cLat = "49.246292"
                cLon = "-123.116226"
                defaults.set(self.cLat, forKey: "hostel_lat")
                defaults.set(self.cLon, forKey: "hostel_lon")
                self.txt_location.text = "South Cambie, Vancouver, BC, Canada"
                self.defaults.set("South Cambie, Vancouver, BC, Canada", forKey: "location")
                defaults.set("South Cambie, Vancouver, BC, Canada", forKey:"loctionString")
            case .authorizedAlways, .authorizedWhenInUse:
              locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            print("location")
        }
        
        
    }
    
    @IBAction func searchClose(_ sender: Any) {
        btn_close.alpha = 0
        closeImage.alpha = 0
        searchbar.text = ""
        searchActive = false
        tableview.reloadData()
        searchbar.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        btn_close.alpha = 1
        closeImage.alpha = 1
    }
    
    
    
    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
      self.getResturantsApi()
    }
    
    func AppSliderImages(){
    
        imagesArray = []
     
        
        let url : String = appDelegate.baseUrl+appDelegate.showAppSliderImages
       
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        Alamofire.request(url, method: .post, parameters:nil, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                   self.deleteContentsOfFolder()
                    for Dict in myCountry! {
                        
                        let myRestaurant = Dict["AppSlider"] as! [String:String]
                        let url = URL(string:self.appDelegate.ImagebaseUrl+myRestaurant["image"]! as! String)
                        
                        print("url      \(url)")
                        
                        Alamofire.request(url!).responseData { (response) in
                                        if response.error == nil {
                                                 print(response.result)
                                
                                                 // Show the downloaded image:
                                                 if let data = response.data {
                                                         let image = UIImage(data: data)
                                                    
                                                    let i = UInt64(arc4random())
                                                    
                                                    let str = String(i).appending(".png")
                                                    
                                                    
                                                    
                                                    let fileManager = FileManager.default
                                                    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(str)
                                                    
                                                    
                                                    let imageData = UIImageJPEGRepresentation(image ?? UIImage() ,1.0)
                                                    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
                                            }
                                                     }
                                             }
//                        let data = try? Data(contentsOf: url!)
//                        let image: UIImage = UIImage(data: data!)!
                        //self.imagesArray.add(image)
                      
                    //self.getResturantsApi()
                    //print(self.imagesArray)
                  
                    //self.tableview.reloadData()
                        }
  
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
               
                print(error)
                self.alertModule(title:"Error", msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    func AddFavourite(){
        
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.addFavouriteRestaurant
        var parameter :[String:Any]?
        if(defaults.string(forKey: "uid") == nil || defaults.string(forKey: "uid") == ""){
            parameter = ["user_id":"","restaurant_id":StaticData.singleton.Rest_id!,"favourite":StaticData.singleton.isFavourite!]
        }else{
            
            parameter = ["user_id":defaults.string(forKey: "uid")!,"restaurant_id":StaticData.singleton.Rest_id!,"favourite":StaticData.singleton.isFavourite!]
        }
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    self.getResturantsApi()
                    
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error", msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    func getfilterResturantsApi(){
        
        avglist = []
        totalRatingslist = []
        MenuName = []
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let url : String = appDelegate.baseUrl+appDelegate.showRestaurantsAgainstSpeciality
        
        let parameter :[String:Any]? = ["lat":defaults.string(forKey: "hostel_lat")!,"long":defaults.string(forKey: "hostel_lon")!,"user_id":defaults.string(forKey: "uid")!,"speciality":defaults.string(forKey: "Speciality")!,"current_time":result]
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    self.Resturantlist = []
                    let obj = Restuarant(about:"abc" as! String, delivery_fee:"abc" as! String, image:"abc" as! String , id:"abc" as! String , menu_style:"abc" as! String , name:"abc" as! String , phone:"abc" as! String , slogan:"abc" as! String , totalRating:"abc" as! String , avgRating:"abc" as! String,isFav:"0" as! String,distance:"abc" as! String,cover_image:"abc",currency:"$",tax:"123",promote:"0",preTime:"0",min_order_price:"0",delivery_fee_per_km:"0",delivery_free_range:"",ResAddress:"",est_delivery:"")
                    self.Resturantlist?.add(obj)
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        let myRestaurant = Dict["Restaurant"] as! NSDictionary
                        let myRestaurant1 = Dict["Currency"] as! NSDictionary
                        let myRestaurant2 = Dict["Tax"] as! NSDictionary
                         let min_order_price = myRestaurant["min_order_price"]
                        var avgRating:String? = ""
                        var totalRating:String? = ""
                        if(Dict["TotalRatings"] != nil){
                            let myRating = Dict["TotalRatings"] as! [String:String]
                            avgRating = myRating["avg"]
                            totalRating = myRating["totalRatings"]
                        }
                        let about = myRestaurant["about"]
                        let delivery_fee = myRestaurant["delivery_fee"]
                        let image = myRestaurant["image"]
                        let id = myRestaurant["id"]
                        let menu_style = myRestaurant["menu_style"]
                        let name = myRestaurant["name"]
                        let phone = myRestaurant["phone"]
                        let slogan = myRestaurant["slogan"]
                        let distance1 =  Dict["0"] as! NSDictionary
                        let distance = distance1["distance"]
                        let cover_image = myRestaurant["cover_image"]
                        let currency = myRestaurant1["symbol"]
                        let tax = myRestaurant2["tax"]
                        let est_delivery = myRestaurant2["delivery_time"]
                        let delivery_fee_per_km = myRestaurant2["delivery_fee_per_km"]
                        let isFav = myRestaurant["favourite"] as! String
                        let promote = myRestaurant["promoted"] as! String
                        let preTime = myRestaurant["preparation_time"] as! String
                        print(isFav)
                        //print(distance!)
                        self.MenuName.add(name as! String)
                        var ResAddress = ""
                        if let myRestaurant3 = Dict["RestaurantLocation"] as? [String:String]{
                            
                            let a2:String! =  myRestaurant3["city"]!
                            let b2:String! = myRestaurant3["country"]!
                            ResAddress = a2+" "+b2
                        }
                        let delivery_free_range = myRestaurant["delivery_free_range"]
                        let obj = Restuarant(about:about as! String, delivery_fee: delivery_fee as! String, image:image as! String , id:id as! String , menu_style:menu_style as! String , name:name as! String , phone:phone as! String , slogan:slogan as! String, totalRating:totalRating as! String, avgRating:avgRating as! String,isFav:isFav ,distance:distance as! String,cover_image:cover_image as! String,currency:currency as! String,tax:tax as! String,promote:promote,preTime:preTime,min_order_price:min_order_price as! String,delivery_fee_per_km: delivery_fee_per_km as! String,delivery_free_range: delivery_free_range as! String,ResAddress: ResAddress as! String,est_delivery:est_delivery as! String)
                        self.Resturantlist?.add(obj)
                        //                        self.avglist.add(avg!)
                        //                         self.totalRatingslist.add(totalRatings!)
                        
                        
                    }
                    
                    
                    if(self.Resturantlist?.count == 0){
                        self.innerview.alpha = 1
                       
                        self.tableview.reloadData()
                        //self.alertModule(title:"Error", msg:"NO Restaurant Found.")
                    }else{
                        
                        self.innerview.alpha = 0
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                       
                        self.tableview.reloadData()
                    }
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                self.refreshControl.endRefreshing()
                print(error)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }

    
    func getResturantsApi(){
        
        if(loadingToggle == "yes"){
            
            appDelegate.showActivityIndicatory(uiView:self.view)
            KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        }
                let headers: HTTPHeaders = [
                    "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
                    
                ]
  
        avglist = []
        totalRatingslist = []
        MenuName = []
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        
        let url : String = appDelegate.baseUrl+appDelegate.showRestaurants
    
        let parameter :[String:Any]? = ["lat":defaults.string(forKey: "hostel_lat")!,"long":defaults.string(forKey: "hostel_lon")!,"user_id":defaults.string(forKey: "uid")!,"current_time":result]
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    self.Resturantlist = []
                    let obj = Restuarant(about:"abc" as! String, delivery_fee:"abc" as! String, image:"abc" as! String , id:"abc" as! String , menu_style:"abc" as! String , name:"abc" as! String , phone:"abc" as! String , slogan:"abc" as! String , totalRating:"abc" as! String , avgRating:"abc" as! String,isFav:"0" as! String,distance:"abc" as! String,cover_image:"abc",currency:"$",tax:"123",promote:"0",preTime:"0",min_order_price:"0",delivery_fee_per_km:"0",delivery_free_range:"", ResAddress:"",est_delivery: "")
                    self.Resturantlist?.add(obj)
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        let myRestaurant = Dict["Restaurant"] as! NSDictionary
                        let myRestaurant1 = Dict["Currency"] as! NSDictionary
                        let myRestaurant2 = Dict["Tax"] as! NSDictionary
                        var avgRating:String? = ""
                        var totalRating:String? = ""
                        if(Dict["TotalRatings"] != nil){
                            let myRating = Dict["TotalRatings"] as! [String:String]
                         avgRating = myRating["avg"]
                        totalRating = myRating["totalRatings"]
                        }
                        let about = myRestaurant["about"]
                        let min_order_price = myRestaurant["min_order_price"]
                        let delivery_fee = "0.00"
                        
                        let image = myRestaurant["image"]
                        let id = myRestaurant["id"]
                        let menu_style = myRestaurant["menu_style"]
                        let name = myRestaurant["name"]
                        let phone = myRestaurant["phone"]
                        let slogan = myRestaurant["slogan"]
                        let distance1 =  Dict["0"] as! NSDictionary
                        let distance = distance1["distance"]
                        let cover_image = myRestaurant["cover_image"]
                        let currency = myRestaurant1["symbol"]
                         let tax = myRestaurant2["tax"]
                        let est_delivery = myRestaurant2["delivery_time"]
                        let delivery_fee_per_km = myRestaurant2["delivery_fee_per_km"]
                        let isFav = myRestaurant["favourite"] as! String
                        let promote = myRestaurant["promoted"] as! String
                        let preTime = myRestaurant["preparation_time"] as! String
                        
                        print(isFav)
                        //print(distance!)
                        self.MenuName.add(name as! String)
                        var ResAddress = ""
                        if let myRestaurant3 = Dict["RestaurantLocation"] as? [String:String]{
                            
                            let a2:String! = myRestaurant3["city"]!
                            let b2:String! = myRestaurant3["country"]!
                            ResAddress = a2+" "+b2
                        }
                        let delivery_free_range = myRestaurant["delivery_free_range"]
                        let obj = Restuarant(about:about as! String, delivery_fee: delivery_fee as! String, image:image as! String , id:id as! String , menu_style:menu_style as! String , name:name as! String , phone:phone as! String , slogan:slogan as! String, totalRating:totalRating as! String, avgRating:avgRating as! String,isFav:isFav ,distance:distance as! String,cover_image:cover_image as! String,currency:currency as! String,tax:tax as! String,promote:promote,preTime:preTime,min_order_price:min_order_price as! String,delivery_fee_per_km: delivery_fee_per_km as! String,delivery_free_range: delivery_free_range as! String,ResAddress: ResAddress as! String,est_delivery:est_delivery as! String)
                        
                        self.Resturantlist?.add(obj)
//                        self.avglist.add(avg!)
//                         self.totalRatingslist.add(totalRatings!)
                        
                        
                    }
                    
          
                    if(self.Resturantlist?.count == 0){
                        self.innerview.alpha = 1
                         self.refreshControl.endRefreshing()
                        //self.alertModule(title:"Error", msg:"NO Restaurant Found.")
                    }else{
                        
                        self.innerview.alpha = 0
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                        self.refreshControl.endRefreshing()
                        self.tableview.reloadData()
                    }
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                self.refreshControl.endRefreshing()
                print(error)
            self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    @IBAction func Filter(_ sender: Any) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(searchActive == true){
            return self.filtered.count
        }else{
        return self.Resturantlist!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(searchActive == true){
            
           return 105
        }else{
        if(indexPath.row == 0){
            
            return 220
        }else{
            return 105
            
            }
    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(searchActive == true){
            
            let cell:RTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell1") as! RTableViewCell
            
            let obj = self.filtered[indexPath.row] as! Restuarant
            let today : String!
            
            today = getTodayString()
            if(obj.min_order_price == "0.00"){
               cell.txt_minorder.text = obj.currency+obj.delivery_fee_per_km+"/km"
            }else{
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km- Free over "
                cell.txt_minorder.text = s+obj.currency+obj.min_order_price
                
                
            }
            cell.R_img.layer.masksToBounds = false
            cell.R_img.layer.cornerRadius = cell.R_img.frame.height/2
            cell.R_img.clipsToBounds = true
            cell.R_img.sd_setImage(with: URL(string:self.appDelegate.ImagebaseUrl+obj.image), placeholderImage: UIImage(named: "Unknown"))
            
            cell.txt_estFee.text = obj.est_delivery+" min"
            print(self.appDelegate.ImagebaseUrl+obj.image)
            print(obj.slogan)
            
            cell.R_title.text = obj.name
            cell.R_description.text = obj.slogan
           // cell.rating_count.text = obj.currency+obj.delivery_fee
            print(obj.distance)
            if(obj.distance != "abc"){
            let dist:Float = Float(obj.distance)!*1.6
            cell.R_distance.text = String(format: "%.1f",Float(dist))+"KM"
        }
            if(obj.isFav == "0"){
                
                cell.heart_img.image = UIImage(named: "Unheart")
            }else{
                
                cell.heart_img.image = UIImage(named: "heart")
            }
//
            cell.pre_time.text = obj.preTime+" min"
           cell.btn_favourite.tag = indexPath.row
           cell.btn_favourite.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            if(obj.avgRating == nil || obj.avgRating == "" || obj.avgRating == "abc" ){
                
                cell.rating_view.rating = 0.0000
                
            }else{
                cell.rating_view.rating = Double(obj.avgRating)!
            }
            if(obj.promote == "0"){
            cell.feature_img.alpha = 0
        }else{
            
            cell.feature_img.alpha = 1
        }
          
            return cell
        }else{
        
        if(indexPath.row == 0){
            
            
            let cell:PagerTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell47") as! PagerTableViewCell
      
                var imageSource: [ImageSource] = []
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            do {
                // Get the directory contents urls (including subfolders urls)
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                print(directoryContents)
                
                // if you want to filter the directory contents you can do like this:
                let mp3Files = directoryContents.filter{ $0.pathExtension == "png" }
                print("mp3 urls:",mp3Files)
                let mp3FileNames = mp3Files.map{$0}
                print("mp3 list:", mp3FileNames)
                
                for imagee in mp3FileNames {
                    // let imagePath = fileInDocumentsDirectory(imagee)
                    let img = UIImage(contentsOfFile:imagee.path)
                    imageSource.append(ImageSource(image:img ?? UIImage()))
                }
                //let Str:String = imagesArray[i] as! String
                
              
                
                
                cell.slidesImage.backgroundColor = UIColor.white
                cell.slidesImage.slideshowInterval = 5.0
                cell.slidesImage.pageControlPosition = PageControlPosition.underScrollView
                cell.slidesImage.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
                cell.slidesImage.pageControl.pageIndicatorTintColor = UIColor.red
                cell.slidesImage.contentScaleMode = UIViewContentMode.scaleAspectFill
                //let recognizer = UITapGestureRecognizer(target: self, action: #selector(Calculate1ViewController.didTap))
                //self.slideshow.addGestureRecognizer(recognizer)
                
                cell.slidesImage.activityIndicator = DefaultActivityIndicator()
                cell.slidesImage.currentPageChanged = { page in
                    print("current page:", page)
                }
                //
                //        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource
                cell.activity_indicator.alpha = 0
                cell.slidesImage.setImageInputs(imageSource)
                
            } catch {
                print(error.localizedDescription)
            }
            
         
            
            
            return cell
        }else{
        
        let cell:RTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell1") as! RTableViewCell
        
            let obj = self.Resturantlist![indexPath.row] as! Restuarant
        let today : String!
        
        today = getTodayString()
            if(obj.min_order_price == "0.00"){
                cell.txt_minorder.text = obj.currency+obj.delivery_fee_per_km+"/km"
            }else{
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km- Free over "
                cell.txt_minorder.text = s+obj.currency+obj.min_order_price
                
                
            }
        cell.R_img.layer.masksToBounds = false
        cell.R_img.layer.cornerRadius = cell.R_img.frame.height/2
        cell.R_img.clipsToBounds = true
        cell.R_img.sd_setImage(with: URL(string:self.appDelegate.ImagebaseUrl+obj.image), placeholderImage: UIImage(named: "Unknown"))
 
        print(obj.slogan)
            cell.pre_time.text = obj.preTime+" min"
        cell.txt_estFee.text = obj.est_delivery+" min"
        cell.R_title.text = obj.name
        cell.R_description.text = obj.slogan
        //cell.rating_count.text = obj.currency+obj.delivery_fee
            if(obj.isFav == "0"){
                
                cell.heart_img.image = UIImage(named: "Unheart")
            }else{
                
                cell.heart_img.image = UIImage(named: "heart")
            }
            cell.btn_favourite.tag = indexPath.row
         cell.btn_favourite.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            print(obj.avgRating)
            //cell.txt_minorder.text = obj.currency+obj.min_order_price
            if(obj.avgRating == nil || obj.avgRating == ""){
                
                cell.rating_view.rating = 0.0000
                
            }else{
                cell.rating_view.rating = Double(obj.avgRating)!
            }
            
            let dist:Float = Float(obj.distance)!*1.6
            print(dist)
            cell.R_distance.text = String(format: "%.1f",Float(dist))+" KM"
            if(obj.promote == "0"){
                cell.feature_img.alpha = 0
            }else{
                
                cell.feature_img.alpha = 1
            }
  
        return cell
            
        }
            
        }
    }
    
    @objc func buttonClicked(sender: UIButton) {
        let buttonRow = sender.tag
        print(buttonRow+1)
        let indexPath = IndexPath(row:buttonRow, section:0)
        let obj =   Resturantlist![buttonRow] as! Restuarant
        let cell = tableview.cellForRow(at:indexPath) as! RTableViewCell
        if(cell.heart_img.image ==
            UIImage(named: "Unheart")){
            if(defaults.string(forKey: "uid") == nil || defaults.string(forKey: "uid") == ""){
                
            }else{
                cell.heart_img.image = UIImage(named: "heart")
                StaticData.singleton.Rest_id = obj.id
                StaticData.singleton.isFavourite = "1"
                AddFavourite()
            }
        }else{
            if(defaults.string(forKey: "uid") == nil || defaults.string(forKey: "uid") == ""){
                
            }else{
           cell.heart_img.image = UIImage(named: "Unheart")
          
                StaticData.singleton.Rest_id = obj.id
                StaticData.singleton.isFavourite = "0"
                AddFavourite()
            }
            }
        print(buttonRow)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(searchActive == true){
            
            let obj = self.filtered[indexPath.row] as! Restuarant
            print(obj.name)
            StaticData.singleton.Rest_name = obj.name
            StaticData.singleton.Rest_id = obj.id
            StaticData.singleton.Rest_image = obj.image
            StaticData.singleton.Rest_Cimage = obj.cover_image
            StaticData.singleton.Rest_salogan = obj.slogan
            UserDefaults.standard.set(StaticData.singleton.Rest_name!, forKey: "rest")
            StaticData.singleton.Rest_rating = obj.avgRating
            StaticData.singleton.Rest_About = obj.about
            StaticData.singleton.currSymbol = obj.currency
            StaticData.singleton.restFee = obj.delivery_fee
            StaticData.singleton.restTax = obj.tax
            StaticData.singleton.MinOrderprice = obj.min_order_price
            //StaticData.singleton.RangeFee = obj.delivery_free_range
            
            
            if(obj.delivery_free_range == "0"){
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km"
                StaticData.singleton.MenuDelFee = s
                
            }else{
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km - free delivery over "+obj.currency+obj.min_order_price+" within "+obj.delivery_free_range+" km"
                StaticData.singleton.MenuDelFee = s
            }
           
  
            
            self.performSegue(withIdentifier:"orders", sender: nil)
        }else{
            
        
        if(indexPath.row == 0){
            
            print(indexPath.row)
            
        }else{
            
           
            print(indexPath.row)
            
            let obj = self.Resturantlist![indexPath.row] as! Restuarant
            print(obj.name)
        StaticData.singleton.Rest_name = obj.name
        StaticData.singleton.Rest_id = obj.id
       StaticData.singleton.Rest_image = obj.image
        StaticData.singleton.Rest_Cimage = obj.cover_image
        StaticData.singleton.Rest_salogan = obj.slogan
         StaticData.singleton.Rest_About = obj.about
            UserDefaults.standard.set(StaticData.singleton.Rest_name!, forKey: "rest")
        StaticData.singleton.Rest_rating = obj.avgRating
        StaticData.singleton.currSymbol = obj.currency
            StaticData.singleton.restFee = obj.delivery_fee
            StaticData.singleton.restTax = obj.tax
            StaticData.singleton.MinOrderprice = obj.min_order_price
            //StaticData.singleton.RangeFee = obj.delivery_free_range
            if(obj.delivery_free_range == "0"){
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km"
                StaticData.singleton.MenuDelFee = s
                
            }else{
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km - free delivery over "+obj.currency+obj.min_order_price+" within "+obj.delivery_free_range+" km"
                StaticData.singleton.MenuDelFee = s
            }
            
            // StaticData.singleton.MenuDelFee = s
        self.performSegue(withIdentifier:"orders", sender: nil)
        }
            
        }
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
       
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
 
  
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        self.getResturantsApi()
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let string1 = string
        let string2 = String(searchbar.text!)
        var finalString = ""
        if (string1.characters.count>0) { // if it was not delete character
            finalString = string2 + string1
        }
        else if (string2.characters.count > 0){ // if it was a delete character
            
            finalString = String(string2.characters.dropLast())
        }
        
        filteredArray(searchString: finalString as String)
        
        return true
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func filteredArray(searchString:String){// we will use NSPredicate to find the string in array
       self.filtered.removeAllObjects()
        if((self.Resturantlist?.count)! > 0){
            for i in 0...(Resturantlist?.count)!-1{
                let obj = Resturantlist![i] as! Restuarant
                if obj.name!.lowercased().range(of:searchString) != nil {
                    if(obj.name! == "abc"){}else{
                     self.filtered.add(obj)
                    }
                }
            }
        }
        //let resultPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchString)
       // filtered = Resturantlist?.filtered(using: resultPredicate) as! NSArray
    
        print(filtered)
        
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableview.reloadData()
        
    }
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
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
        

        
        StaticData.singleton.isLocation = "YES"
        
        let LoginVC:GetMapLocationViewController =  (storyboard!.instantiateViewController(withIdentifier: "GetMapLocationViewController") as? GetMapLocationViewController)!
        LoginVC.Current_location = self.txt_location.text
        LoginVC.Current_lat = defaults.string(forKey:"hostel_lat")
        LoginVC.Current_lon = defaults.string(forKey:"hostel_lon")
      
        self.present(LoginVC, animated:true, completion: nil)

        
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
    func deleteContentsOfFolder(){
        
         let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "png" }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{$0}
            print("mp3 list:", mp3FileNames)
        for file in mp3Files {
            try FileManager.default.removeItem(atPath:file.path)
        }
        } catch {
            print(error.localizedDescription)
        }
    }
  
   
 
}
