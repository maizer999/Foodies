//
//  Jobs1ViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/4/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON
import CoreLocation
import PopupDialog
import FirebaseAuth
import FirebaseDatabase
import Foundation
import SystemConfiguration


class Jobs1ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var btn_bar: UIBarButtonItem!
    
    var st:NSMutableArray = []
    var ed:NSMutableArray = []
    var locationManager:CLLocationManager!
    var center:CLLocationCoordinate2D! = nil
    var refreshControl = UIRefreshControl()
    var pre_lat:String! = "0.0"
    var pre_long:String! = "0.0"
    var buttonTag:Int! = 0
    
    
    var loadingToggle:String? = "yes"
    
    @IBOutlet weak var view1: UIView!
    
    var lat:Double? = 0.0
    var lon:Double? = 0.0
    
    
    @IBOutlet weak var txt_time_lbl: UILabel!
    
    @IBOutlet weak var txt_upperlabl: UILabel!
    
    
    @IBOutlet weak var view2: UIView!
    var selectedProgram:Riderorder?
    
    var timer = Timer()
    
    @IBOutlet weak var tableview: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var Sections:NSMutableArray = ["PENDING JOBS","CURRENT JOBS"]
    
    var Pending:NSMutableArray = []
    @objc var Accept:NSMutableArray = []
    
    var toogle:String = "PENDING JOBS"
     var orderID:String = ""
     var Status:String = ""
    
    var childRef30 = FIRDatabase.database().reference().child("RiderOrdersList").child(UserDefaults.standard.string(forKey: "uid")!).child("CurrentOrders")
    var childRef31 = FIRDatabase.database().reference().child("RiderOrdersList").child(UserDefaults.standard.string(forKey: "uid")!).child("PendingOrders")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(applicationDidEnterBackground),
//                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
//                                               object: nil)
        let font = UIFont(name: "Verdana", size:15)
        btn_bar.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!], for: .normal)
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(RestuarntsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableview?.addSubview(refreshControl)

       
       
       
    }
    override func viewWillDisappear(_ animated: Bool) {
  
        self.timer.invalidate()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Jobs"
        let view1 = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:20))
        view1.backgroundColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        self.navigationController?.view.addSubview(view1)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            self.UserLocationApi()
        }
        self.showUpComingRiderShifts()
        self.ShowRiderStatus()
         //self.getOrderApi()
        
        if(StaticData.singleton.isChat == "yes"){
            
            tabBarController?.selectedIndex = 1
            StaticData.singleton.isChat = "no"
        }
        
        
    }
  
    
//    @objc func applicationDidEnterBackground() {
//        locationManager.startUpdatingLocation()
//    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
        self.OrderApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    func OrderApi(){
        
        let isValid:Bool = self.isInternetAvailable()
        
        if(isValid){
            if(loadingToggle == "yes"){
                
                KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
            }
           
                
                childRef30.observe(.value) { (snapshot) in
                    self.Pending = []
                    
                    if snapshot.childrenCount > 0 {
                        
                        
                        for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                            let artistObject = artists.value as? [String: AnyObject]
                            let key = artists.key
                            print(artistObject!)
                            let order_id = artistObject?["order_id"] as! String
                            let hotel_name = artistObject?["restaurants"] as! String
                            let order_price = artistObject?["price"] as! String
                            let symbol = artistObject?["symbol"] as! String
                            let status = artistObject?["status"] as! String
                            
                            
                            let obj = RiderSide(order_id:order_id, hotel_name:hotel_name, order_price:order_price,key:key,symbol:symbol,status:status)
                            self.Pending.add(obj)
                        }
                        KRProgressHUD.dismiss {
                            print("dismiss() completion handler.")
                        }
                        
                      
                        self.refreshControl.endRefreshing()
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                        self.tableview.reloadData()
                    }else{
                        self.Pending = []
                        KRProgressHUD.dismiss {
                            print("dismiss() completion handler.")
                        }
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                        self.tableview.reloadData()
                        
                       
                        self.refreshControl.endRefreshing()
                        
                        
                    }
                }
            
                
                childRef31.observe(.value) { (snapshot) in
                    self.Accept = []
                    
                    
                    if snapshot.childrenCount > 0 {
                        
                        for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                            let artistObject = artists.value as? [String: AnyObject]
                            print(artistObject!)
                            
                            let key = artists.key
                            print(artistObject!)
                            let order_id = artistObject?["order_id"] as! String
                            let hotel_name = artistObject?["restaurants"] as! String
                            let order_price = artistObject?["price"] as! String
                            let symbol = artistObject?["symbol"] as! String
                            let status = artistObject?["status"] as! String
                            
                            
                            let obj = RiderSide(order_id:order_id, hotel_name:hotel_name, order_price:order_price,key:key,symbol:symbol,status:status)
                            self.Accept.add(obj)
                        }
                        KRProgressHUD.dismiss {
                            print("dismiss() completion handler.")
                        }
                       
                        self.refreshControl.endRefreshing()
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                        self.tableview.reloadData()
                    }else{
                        self.Accept = []
                        KRProgressHUD.dismiss {
                            print("dismiss() completion handler.")
                        }
                        
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                        self.tableview.reloadData()
                        
                        self.refreshControl.endRefreshing()
                        
                        
                    }
                }
            
        }else{
            
            self.alertModule(title:"Error", msg:"The Internet connection appears to be offline.")
        }
        
    }
  
    func numberOfSections(in tableView: UITableView) -> Int  {
   
        return Sections.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            
             return Accept.count
            
        }else{
            return Pending.count
           
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 54
        
        }else{
            
           return 112
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
   
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        
        return self.Sections[section] as! String
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.init(red:235/255.0, green:235/255.0, blue:235/255.0, alpha: 1.0)
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y:10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
      
        headerLabel.font = UIFont.systemFont(ofSize:12, weight:UIFont.Weight.regular)
        headerLabel.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
   
        headerLabel.text = self.tableView(self.tableview, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
       
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       if(indexPath.section == 0){
        let cell:riderTableViewCell = tableview.dequeueReusableCell(withIdentifier: "10th") as! riderTableViewCell
        if(Accept.count > 0){
            
        
        
              let obj = Accept[indexPath.row] as! RiderSide
    
       
        
        cell.rider_order.text = "Order #"+obj.order_id
        cell.hotel_name.text = obj.hotel_name
       
        cell.rider_price.text = obj.symbol+obj.order_price
      
        }
        return cell
        }else{
       let cell:AcceptTableViewCell = tableview.dequeueReusableCell(withIdentifier: "11th") as! AcceptTableViewCell
            if(Pending.count > 0){
            
            let obj = Pending[indexPath.row] as! RiderSide
        
        cell.btn_aacept.tag = indexPath.row
        
        cell.btn_aacept.addTarget(self, action: #selector(Accepted(sender:)), for: .touchUpInside)
      
        
        cell.acc_order.text = "Order #"+obj.order_id
        cell.acc_hotel.text = obj.hotel_name
        
       
        
        cell.acc_price.text = obj.symbol+obj.order_price
      
          
            
            
        }
        return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
           let obj = Accept[indexPath.row] as! RiderSide
            StaticData.singleton.OrderId = obj.order_id
             StaticData.singleton.currSymbol = obj.symbol
        
            StaticData.singleton.hideRiderBtn = "no"
            
        
        self.performSegue(withIdentifier:"showjob", sender:nil)
        }
    }
    
    @objc func Accepted(sender: UIButton){
        buttonTag = sender.tag
         let obj = Pending[buttonTag] as! RiderSide
        orderID = obj.order_id
        Status = "1"
       self.UpdateOrderStatus()
        
    }
    @objc func Decline(sender: UIButton){
        let buttonTag = sender.tag
        let obj = Pending[buttonTag] as! Riderorder
        orderID = obj.orderid
        Status = "2"
        self.UpdateOrderStatus()
        
    }
    
    func showUpComingRiderShifts(){
        
        self.txt_upperlabl.text = "Hey "+UserDefaults.standard.string(forKey: "first_name")!+", looking for more orders?"
  
        let url : String = appDelegate.baseUrl+appDelegate.showUpComingRiderShifts
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"datetime":result]
        //print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                self.st = []
                self.ed = []
                let json  = value
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    let dict = dic["msg"] as! [[String:Any]]
                    for dictionary in dict{
                        
                        let myTimming = dictionary["RiderTiming"] as! NSDictionary
                        self.st.add(myTimming["starting_time"] as! String)
                        self.ed.add(myTimming["ending_time"] as! String)
                    }
                    if(self.st.count == 0 && self.ed.count == 0){
                        
                        self.txt_time_lbl.text = "No Availbility"
                        
                    }else{
                        
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "HH:mm:ss"
                        let showDate = inputFormatter.date(from:self.st[0] as! String)
                        inputFormatter.dateFormat = "hh:mm a"
                        let day1 = inputFormatter.string(from:showDate!)
                        let inputFormatter1 = DateFormatter()
                        inputFormatter1.dateFormat = "HH:mm:ss"
                        let showDate1 = inputFormatter1.date(from:self.ed[0] as! String)
                        inputFormatter1.dateFormat = "hh:mm a"
                        let day2 = inputFormatter.string(from:showDate1!)
                        self.txt_time_lbl.text = day1+"-"+day2
                        
                    }
                    
                }else{
                    
                    
                    //self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
                
            case .failure(let error):
               
                print(error)
                //self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    func UpdateOrderStatus(){

        
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let url : String = appDelegate.baseUrl+appDelegate.updateRiderOrderStatus
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["order_id":orderID,"status":Status]
        //print(url)
         //print(parameter!)
        
        Alamofire.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
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
                    let obj = self.Pending[self.buttonTag] as! RiderSide
                    self.childRef30.observeSingleEvent(of:.value, with: { (snapshot) in
                        
                        if snapshot.childrenCount > 0 {
                            for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                                let artistObject = artists.value as? [String: AnyObject]
                                let key = artists.key
                                let order_id = artistObject?["order_id"] as! String
                                let hotel_name = artistObject?["restaurants"] as! String
                                let order_price = artistObject?["price"] as! String
                                let symbol = artistObject?["symbol"] as! String
                                let status = artistObject?["status"] as! String
                                if(obj.key == key){
                                    let message = ["order_id":order_id ,"restaurants":hotel_name,"price":order_price,"symbol":symbol,"status":status] as [String : Any]
                                    
                                    self.childRef30.child(key).removeValue()
                                    self.childRef31.child(key).setValue(message)
                                }
                            }
                        }
                    })
                   
                    //self.OrderApi()
                    
                }else{
                    
                    
                   // self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
                
            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showjob") {
            StaticData.singleton.showOrderToggle = "NO"
            let vc = segue.destination as! jobs2ViewController
            vc.myDict =  selectedProgram
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        lat = userLocation.coordinate.latitude
        lon = userLocation.coordinate.longitude
    
        center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        if( UserDefaults.standard.string(forKey:"UserType") == "rider"){
            
        self.UserLocationApi()
             let childTrack = FIRDatabase.database().reference().child("tracking").child(UserDefaults.standard.string(forKey: "uid")!)
            let message = ["rider_lat":String(lat!),"rider_long":String(lon!),"rider_previous_lat":pre_lat,"rider_previous_long":pre_long]
            self.pre_long = String(lon!)
            self.pre_lat = String(lat!)
            
            childTrack.setValue(message)
            
        }
       
       //manager.stopUpdatingLocation()
        
    }
    
    func UserLocationApi(){

        
        let url : String = appDelegate.baseUrl+appDelegate.addUserLocation
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        if(lat == nil && lat == nil){
            
            lat = 71.001456
            lon = 32.123456
        }
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"lat":String(lat!),"long":String(lon!)]
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
                    
                
                    
                }else{
                    
                    
                    //self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
              
                print(error)
                //self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    func UserLocation(){
        
   
                
        self.UserLocationApi()
                

    }
    
    func ShowRiderStatus(){
        
        let url : String = appDelegate.baseUrl+appDelegate.showUserOnlineStatus
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!]
        //print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    let myCountry = dic["msg"] as? String
                    
                    
                    if(myCountry! == "1"){
                        UserDefaults.standard.set("0", forKey:"checkin")

                        self.btn_bar.title = "Check Out"
                        StaticData.singleton.statusChecking = "Check In"
                        self.OrderApi()
                        
                    }else{
                        UserDefaults.standard.set("1", forKey:"checkin")
                      
                       self.btn_bar.title = "Check In"
                        StaticData.singleton.statusChecking = "Check Out"
                        
                    }
                    
                }else{
                    
                   // self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
                
            case .failure(let error):
                
                print(error)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
 

}
