//
//  jobs2ViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/4/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON
import FirebaseAuth
import FirebaseDatabase

class jobs2ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var orderid:String! = ""
    var created:String! = ""
    var price:String! = ""
    var last_name:String! = ""
    var phone:String! = ""
    var user_id:String! = ""
    var User_address:String! = ""
    var first_name:String! = ""
    var rest_name:String! = ""
    var rest_salogan:String! = ""
    var rest_phone:String! = ""
    var latitude:String! = ""
    var longitude:String! = ""
    var Rest_address:String! = ""
    var Rest_latitute:String! = ""
    var Rest_longitude:String! = ""
    var User_Instruction:String! = ""
    var cod:String! = ""
    var symbol:String! = ""
    var fee:String! = "0.0"
    var per:String! = ""
    var sub_total:String! = ""
    var colltime:String! = ""
    var deltime:String! = ""
    var riderTip:String! = ""
    var riderIns:String! = ""
    var taxFree:String! = "0.0"
    var taxValue:String! = "0.0"
    var childRef41 = FIRDatabase.database().reference().child("RiderOrdersList").child(UserDefaults.standard.string(forKey: "uid")!).child("PendingOrders")
    
    @IBOutlet weak var rider_hotel: UILabel!
    
    @IBOutlet weak var rider_order: UILabel!
    
    @IBOutlet weak var rider_payment: UILabel!
    
    @IBOutlet weak var rider_price: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var time: UILabel!
    
 
    
    
    @IBOutlet weak var address: UILabel!
   
 
    
   
    
    @IBOutlet weak var btn_way: UIButton!
    
   
    
    var on_my_way_to_hotel_time:String! = ""
    var pickup_time:String! = ""
    var on_my_way_to_user_time:String! = ""
    var delivery_time:String! = ""
    
 
   
    
    var myDict:Riderorder!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
  
  
    
    @IBOutlet weak var view3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rider_order.text = "Order #"+StaticData.singleton.OrderId!
        self.symbol = StaticData.singleton.currSymbol!
        
   
        if(StaticData.singleton.hideRiderBtn == "yes"){
            
            btn_way.alpha = 0
            
        }else{
            
            btn_way.alpha = 1
        }

        
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
     
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Order #"+StaticData.singleton.OrderId!
        self.GiveOrderDetailApi()
        self.showRiderTrackingApi()
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Collectjob") {
            let vc = segue.destination as! CollectViewController
            vc.cDict = myDict
        }else if (segue.identifier == "Deliverjob") {
      
            let vc = segue.destination as! DeliverViewController
            vc.dDict = myDict
        }
    }
    
  
    func alertModule1(title:String,msg:String){
       
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        let alertAction2 = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction!) in
         
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:")!) {
                var urlString = "comgooglemaps://?ll=\((self.Rest_latitute! as! NSString).doubleValue),\((self.Rest_longitude! as! NSString).doubleValue)&daddr=\((self.Rest_latitute! as! NSString).doubleValue),\((self.Rest_longitude! as! NSString).doubleValue)"
                print(urlString)
                UIApplication.shared.openURL(URL(string: urlString)!)
            }
            else {
                var urlString = "comgooglemaps://?ll=\((self.Rest_latitute! as! NSString).doubleValue),\((self.Rest_longitude! as! NSString).doubleValue)&daddr=\((self.Rest_latitute! as! NSString).doubleValue),\((self.Rest_longitude! as! NSString).doubleValue)"
                print(urlString)
                UIApplication.shared.openURL(URL(string: urlString)!)
            }
            
            
        })
        
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
       
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func alertModule2(title:String,msg:String){
        
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        let alertAction2 = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction!) in
            
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:")!) {
                var urlString = "comgooglemaps://?ll=\((self.Rest_latitute! as! NSString).doubleValue),\((self.Rest_longitude! as! NSString).doubleValue)&daddr=\((self.latitude! as! NSString).doubleValue),\((self.longitude as! NSString).doubleValue)"
                print(urlString)
                UIApplication.shared.openURL(URL(string: urlString)!)
            }
            else {
                var string = "http://maps.google.com/maps//?ll=\((self.Rest_latitute! as! NSString).doubleValue),\((self.Rest_longitude! as! NSString).doubleValue)&daddr=\((self.latitude! as! NSString).doubleValue),\((self.longitude as! NSString).doubleValue)"
                UIApplication.shared.openURL(URL(string: string)!)
            }
            
            
        })
        
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
     
        present(alertController, animated: true, completion: nil)
        
    }

    func GiveOrderDetailApi(){
     
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let url : String = appDelegate.baseUrl+appDelegate.showOrderDetail
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]?
        
        parameter  = ["order_id":StaticData.singleton.OrderId!]
        
        // print(url)
        print(parameter!)
        
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
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                    
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        let order = Dict["Order"] as! [String:Any]
                        let order1 = Dict["Restaurant"] as! [String:Any]
                        
                        let order2 = order1["RestaurantLocation"] as! [String:String]
                        let order3 = Dict["UserInfo"] as! [String:String]
                        let order4 = order1["Tax"] as! [String:String]
                        
                        self.sub_total = order["sub_total"] as! String
                        self.taxFree = order1["tax_free"] as! String
                        self.taxValue = order["tax"] as! String
                        if let order5 = Dict["Address"] as? [String:String] {
                            
                            self.latitude = order5["lat"]
                            self.longitude = order5["long"]
                            let a2:String! = order5["street"]!+" ,"+order5["city"]!
                            let b2:String! = order5["country"]!
                            self.riderIns = order5["instructions"]
                            self.User_address = a2+" ,"+b2
                        }else{
                            self.User_address = "Pick Up"
                            
                        }
                        self.riderTip = order["rider_tip"] as! String
                        if let dictionary:NSDictionary = Dict["RiderOrder"] as? NSDictionary{
                            
                            if let order9 = dictionary["EstimateReachingTime"] as? NSDictionary{
                                
                                self.colltime = order9["estimate_collection_time"] as! String
                                self.deltime = order9["estimate_delivery_time"] as! String
                            }
                            
                          
                            
                            
                            
                            
                        }else{
                            
                            StaticData.singleton.map_name = ""
                            
                            StaticData.singleton.map_phone = ""
                            StaticData.singleton.rider_lat = ""
                            StaticData.singleton.rider_lon = ""
                            
                        }
                        
                        
                        
                         self.User_Instruction = order["accepted_reason"] as? String
                        self.created = order["created"] as? String
                        let s = order["price"] as! String
                        self.price = s
                        self.rest_name = order1["name"] as? String
                        self.rest_phone  = order1["phone"] as? String
                        let a1:String! = order2["street"]!+" ,"+order2["city"]!
                        let b1:String! = order2["country"]!
                        self.Rest_latitute =  order2["lat"] as! String
                        self.Rest_longitude =  order2["long"] as! String
                        
                        
                        
                        
                        self.fee = order["delivery_fee"] as? String
                       
                        self.first_name = order3["first_name"] as? String
                        self.last_name = order3["last_name"]! as? String
                        self.phone = order3["phone"] as? String
                        
                        if(order["cod"] as! String == "0"){
                            
                            self.cod = "0"
                            
                        }else{
                            
                            self.cod = "1"
                        }
                        
                        self.Rest_address = a1+" ,"+b1
                        
                 
                        }
                    let myString:String = self.created
                            var myStringArr = myString.components(separatedBy:" ")
                            let time1 = myStringArr[1]
                    
                            let dateFormatter = DateFormatter()
                    
                            dateFormatter.dateFormat = "HH:mm:ss"
                    
                            let fullDate = dateFormatter.date(from: time1 )
                    
                            dateFormatter.dateFormat = "hh:mm a"
                    
                            let time2 = dateFormatter.string(from: fullDate!)
                    self.time.text = time2
                    
                            self.address.text = self.Rest_address
                           
                            self.rider_hotel.text = self.rest_name
                            if(self.cod == "0"){
                                self.rider_payment.text = "Credit Card"
                            }else{
                    
                                self.rider_payment.text = "Cash On Delivery"
                            }
                    
                            self.rider_price.text = self.symbol+self.price
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                
                
                
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
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
    

    
    func showRiderTrackingApi(){

        appDelegate.showActivityIndicatory(uiView: self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.showRiderTracking
        
        let parameter :[String:Any]? = ["order_id":StaticData.singleton.OrderId!]
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
                  
                    let myCountry = dic["msg"] as? String
                    print(myCountry!)
                    
                    self.btn_way.setTitle(myCountry?.uppercased(), for: .normal)
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
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
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
       
        present(alertController, animated: true, completion: nil)
        
    }
    

    @IBAction func OnMyWayAction(_ sender: Any) {
        
        
        appDelegate.showActivityIndicatory(uiView: self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        var parameter :[String:Any]? = [:]
        
        let url : String = appDelegate.baseUrl+appDelegate.trackRiderStatus
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:MM:ss"
            let myTime = formatter.string(from: Date())
            
            parameter = ["order_id":StaticData.singleton.OrderId!,"time":myTime]
            
       
        
   
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
                    
                    let myCountry = dic["msg"] as? String
                    print(myCountry!)
                    self.btn_way.setTitle(myCountry?.uppercased(), for: .normal)
                    if(myCountry == "order completed" || myCountry == "order already completed"){
                        self.childRef41.observeSingleEvent(of:.value, with: { (snapshot) in
                            
                            if snapshot.childrenCount > 0 {
                                for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                                    let artistObject = artists.value as? [String: AnyObject]
                                    let key = artists.key
                                    let order_id = artistObject?["order_id"] as! String
                                    
                                    if(order_id == StaticData.singleton.OrderId!){
                                      
                                        
                                        self.childRef41.child(key).removeValue()
                                        self.navigationController?.popViewController(animated: true)
                                        
                                }
                                    
                            }
                            }
                                
                            
                        })
                        
                        
                    }
             
                    
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 1053
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
            
            let cell:TrackTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "49thCell") as! TrackTableViewCell
            if(self.cod == "0"){
                
                cell.subprice.text = "Credit Card"
            }else{
                
                cell.subprice.text = "COD"
            }
        if(self.cod == "0"){
            
            cell.mPay_lbl.alpha = 0
            cell.txt_payRest.alpha = 0
            cell.pay_view.alpha = 0
            cell.image_lbl.alpha = 0
            cell.mTotal_lbl.text = "Total"
        }else{
            cell.mPay_lbl.alpha = 1
            cell.txt_payRest.alpha = 1
            cell.pay_view.alpha = 1
            cell.image_lbl.alpha = 1
            cell.mTotal_lbl.text = "Collect From Customer"
            
        }
            
            cell.payment_name.text = self.symbol+price
            cell.hotel_name.text = rest_name
            cell.total_name.text = self.symbol+sub_total
            cell.hortel_address.text = Rest_address
            cell.hotel_phone.text = rest_phone
            cell.user_name.text = first_name+" "+last_name
            cell.user_address.text = self.User_address
            cell.user_phone.text = phone
            cell.txt_fee.text = self.symbol+fee
            cell.txt_per.text = ""
        cell.txt_tip.text = self.symbol+riderTip
        cell.txt_collection.text = colltime
        cell.txt_delivery.text = deltime
        cell.txt_Addins.text = riderIns
        
            cell.txt_tax.text =  self.symbol+taxValue
        let a1:Float! = Float(self.riderTip)
        let a2:Float! = Float(fee)
        let a3:Float! = a1+a2
        let a5:Float! = Float(price)
        
        let a4:Float! = a5-a3
        print(a4)
        cell.txt_payRest.text = self.symbol+String(format: "%.2f",Float(a4))
        cell.txt_instruction.text = User_Instruction
           
            cell.btn_restAddress.addTarget(self, action: #selector(Accepted1(sender:)), for: .touchUpInside)
        cell.btnrestPhone.addTarget(self, action: #selector(Accepted2(sender:)), for: .touchUpInside)
        cell.btnuserAddress.addTarget(self, action: #selector(Accepted3(sender:)), for: .touchUpInside)
        cell.btnuserphone.addTarget(self, action: #selector(Accepted4(sender:)), for: .touchUpInside)
            
            return cell
        }
    
    @objc func Accepted1(sender: UIButton){
        
       self.alertModule1(title:"Warning", msg:"Are you sure to want exit?")
        
        
    }
    @objc func Accepted2(sender: UIButton){
        if let phoneCallURL = URL(string: "tel://"+self.rest_phone) {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        
    }
    @objc func Accepted3(sender: UIButton){
        
       self.alertModule2(title:"Warning", msg:"Are you sure to want exit?")
        
        
    }
    
    @IBAction func DetailOrder(_ sender: Any) {
        
        StaticData.singleton.OrderId = StaticData.singleton.OrderId!
        StaticData.singleton.isTrack = "1"
        self.performSegue(withIdentifier:"riderDetail", sender:nil)
    }
    
    @objc func Accepted4(sender: UIButton){
        if let phoneCallURL = URL(string: "tel://"+self.phone) {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        
    }
        
    }

    


