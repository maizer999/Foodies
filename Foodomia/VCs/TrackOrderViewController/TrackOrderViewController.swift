//
//  TrackOrderViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/10/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD
import ImageSlideshow

class TrackOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
   var txt_total:String! = "0.0"
    var rider_tip:String! = "0.0"
    
    @IBOutlet weak var trackView: UIView!
    
    
   var txt_payment:String! = ""
    var val:Float! = 0.0
    var tottal:Float! = 0.0
    
    
    
    @IBOutlet weak var btn_track: UIButton!
    
    var AddIns:String! = ""
    
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var txt_instruction: UILabel!
    
    var notificaionArray = [Cart]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        txt_instruction.sizeToFit()
        
        self.title = "Order #"+StaticData.singleton.OrderId!
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        StaticData.singleton.OrderServiceFee  = "0.0"
        self.GiveOrderDetailApi()
        if(StaticData.singleton.isTrack == "0"){
            trackView.alpha = 1
        }else{
            
            trackView.alpha = 0
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        StaticData.singleton.OrderServiceFee = "0.0"
    }
   
    
    
    func GiveOrderDetailApi(){
        

        notificaionArray = []
        
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let url : String = appDelegate.baseUrl+appDelegate.showOrderDetail
        
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
                        StaticData.singleton.tax_free = order1["tax_free"] as! String
                        StaticData.singleton.taxValue = order["tax"] as! String
                        if let order5 = Dict["Address"] as? [String:String] {
                            
                            StaticData.singleton.User_lat = order5["lat"]
                            StaticData.singleton.User_lon = order5["long"]
                            let a2:String! = order5["street"]!+" ,"+order5["city"]!
                            let b2:String! = order5["country"]!
                            self.AddIns = order5["instructions"] as? String
                            StaticData.singleton.UserAddress = a2+" ,"+b2
                        }else{
                            StaticData.singleton.UserAddress = "Pick Up"
                            
                        }
                        self.rider_tip = order["rider_tip"] as! String
                        if let dictionary:NSDictionary = Dict["RiderOrder"] as? NSDictionary{
                         
                          if let order9 = dictionary["EstimateReachingTime"] as? NSDictionary{
                                
                                StaticData.singleton.coll_time = order9["estimate_collection_time"] as! String
                                StaticData.singleton.del_time = order9["estimate_delivery_time"] as! String
                            }
                           
                            if let order7 = dictionary["RiderLocation"] as? NSDictionary{
                                StaticData.singleton.rider_lat = order7["lat"] as? String
                                StaticData.singleton.rider_lon = order7["long"] as? String
                            }
                            if let order8 = dictionary["Rider"] as? NSDictionary{
                                let first = order8["first_name"] as? String
                                let last = order8["last_name"] as? String
                                
                                StaticData.singleton.map_name = first!+" "+last!
                                
                                StaticData.singleton.map_phone = order8["phone"] as? String
                                
                            }
                       
                        
                        
                            
                        }else{
                        
                        StaticData.singleton.map_name = ""
                        
                        StaticData.singleton.map_phone = ""
                        StaticData.singleton.rider_lat = ""
                        StaticData.singleton.rider_lon = ""
                        
                        }
    
                        
                       
                        self.txt_instruction.text = order["instructions"] as? String
                        let s = order["price"] as! String
                        self.txt_total = s
                        StaticData.singleton.OrderHotel = order1["name"] as? String
                        StaticData.singleton.OrderPhone = order1["phone"] as? String
                        let a1:String! = order2["street"]!+" ,"+order2["city"]!
                        let b1:String! = order2["country"]!
                       
                       
                        
                        
                        StaticData.singleton.OrderServiceFee = order["delivery_fee"] as? String
                        StaticData.singleton.Ordertax = order4["tax"] as? String
                        self.val = Float(order4["tax"] as! String)
                        self.tottal = Float(order["sub_total"] as! String)
                        StaticData.singleton.OrderUsername = (order3["first_name"] as? String)!+" "+order3["last_name"]! as? String
                        StaticData.singleton.OrderUserPhone = order3["phone"] as? String
                       
                        if(order["cod"] as! String == "0"){
                            
                            self.txt_payment = "Credit Card"
                            
                        }else{
                            
                            self.txt_payment = "COD"
                        }
                        
                        StaticData.singleton.OrderAddress = a1+" ,"+b1
                        if(order["cod"] as! String == "0"){
                            
                            self.txt_payment = "Credit Card"
                            
                        }else{
                            
                            self.txt_payment = "COD"
                        }
                        
                        
                        
                        
                        let myRestaurant = Dict["OrderMenuItem"] as! NSArray
                        if(myRestaurant == nil || myRestaurant.count == 0){}else{
                            for i in 0...myRestaurant.count-1{
                                let tempMenuObj = Cart()
                                let dic1 = myRestaurant[i] as! [String:Any]
                                print(dic1)
                                
                                tempMenuObj.name = dic1["name"] as? String
                                tempMenuObj.myquantity = dic1["quantity"] as? String
                                tempMenuObj.price = dic1["price"] as? String
                                //                            let obj = Menu(id:id!, name:name!, mydescription:mydescription!)
                                //                            self.menulist.add(obj)
                                let RestaurantMenuItem = dic1["OrderMenuExtraItem"] as! NSArray
                                if(RestaurantMenuItem == nil || RestaurantMenuItem.count == 0){}else{
                                    var tempProductList = cartlist()
                                    for j in 0...RestaurantMenuItem.count-1{
                                        let dic2 = RestaurantMenuItem[j] as! [String:Any]

                                        tempProductList.name1 = dic2["name"] as! String
                                        tempProductList.quantity1 = dic2["quantity"] as! String
                                        tempProductList.price1 = dic2["price"] as! String
                                        tempMenuObj.listOfcarts.append(tempProductList)
                                    }
                                }
                                    self.notificaionArray.append(tempMenuObj)
                            }
                        }
                        
                        
                        
                    }
                    
                    print(self.notificaionArray.count)
                    //print(self.menuItemList.count)
                    
                    
                    if(self.notificaionArray.count == 0){
                        
                        // self.alertModule(title:"Error", msg:"NO Menu Found.")
                    }else{
                        
                        self.tableview.reloadData()
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(StaticData.singleton.isTrack == "1"){
        
            return notificaionArray.count
        }else{
            
            return notificaionArray.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(StaticData.singleton.isTrack == "1"){
            return notificaionArray[section].listOfcarts.count
        }else{
            if(section == notificaionArray.count){
                
                return 1
            }else{
                return notificaionArray[section].listOfcarts.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == notificaionArray.count){
            return 1
        }else{
            
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section == notificaionArray.count){
    
                return 971
    
               }else{
        
                    return 40
               }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let headerLabel3 = UILabel(frame: CGRect(x: 0, y:0, width:
            tableView.bounds.size.width, height:1))
        headerLabel3.backgroundColor = UIColor.init(red:242/255.0, green:242/255.0, blue:242/255.0, alpha: 1.0)
        let headerLabel = UILabel(frame: CGRect(x: 15, y:10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        let headerLabel2:UILabel
        if UIScreen.main.nativeBounds.height == 1136
        {
            
            headerLabel2 = UILabel(frame: CGRect(x:230, y:13, width:
                160 , height:20))
        }else if UIScreen.main.nativeBounds.height == 1334{
            
            headerLabel2 = UILabel(frame: CGRect(x:280, y:13, width:
                160 , height:20))
        }else {
            
            headerLabel2 = UILabel(frame: CGRect(x:320, y:13, width:
                160 , height:20))
        }
        headerLabel2.textAlignment = .left
        headerLabel.font = UIFont (name: "Verdana", size:14)
        headerLabel.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
        headerLabel2.font  = UIFont (name: "Verdana", size:14)
        headerLabel2.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
        
        if section < notificaionArray.count {
            
            let obj = notificaionArray[section]
            headerLabel.text = obj.name+" x"+obj.myquantity
            headerLabel2.text = StaticData.singleton.historySymbol!+obj.price
        }
        if(section == notificaionArray.count){
            
            let headerLabel4 = UILabel(frame: CGRect(x: 0, y:0, width:
                tableView.bounds.size.width, height:1))
            headerLabel4.backgroundColor = UIColor.init(red:242/255.0, green:242/255.0, blue:242/255.0, alpha: 1.0)
            headerView.addSubview(headerLabel4)
        }
        
        headerLabel.sizeToFit()
        headerLabel2.sizeToFit()
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerLabel2)
        headerView.addSubview(headerLabel3)
        
        return headerView
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == notificaionArray.count){
            
            let cell:TrackTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "49thCell") as! TrackTableViewCell
            cell.payment_name.text = StaticData.singleton.historySymbol!+txt_total
            cell.total_name.text = StaticData.singleton.historySymbol!+String(format: "%.2f",Float(self.tottal))
            cell.hotel_name.text = StaticData.singleton.OrderHotel
            cell.hortel_address.text = StaticData.singleton.OrderAddress
            cell.hotel_phone.text = StaticData.singleton.OrderPhone
            cell.user_name.text = StaticData.singleton.OrderUsername
           
            cell.user_address.text = StaticData.singleton.UserAddress
           
            cell.user_phone.text = StaticData.singleton.OrderUserPhone
            cell.txt_fee.text = StaticData.singleton.historySymbol!+StaticData.singleton.OrderServiceFee!
            if(StaticData.singleton.tax_free == "1"){
                cell.txt_per.text = "("+"0"+"%"+")"
            
            }else{
                cell.txt_per.text = "("+StaticData.singleton.Ordertax!+"%"+")"
                
            }
            self.val = Float(StaticData.singleton.taxValue)
            cell.txt_tax.text =  StaticData.singleton.historySymbol!+String(format: "%.2f",Float(self.val))
            cell.subprice.text = txt_payment
            cell.txt_collection.text = StaticData.singleton.coll_time
            cell.txt_delivery.text = StaticData.singleton.del_time
            cell.txt_tip.text =  StaticData.singleton.historySymbol!+self.rider_tip
            let a1:Float! = Float(self.rider_tip)
            let a2:Float! = Float(StaticData.singleton.OrderServiceFee!)
            let a3:Float! = a1+a2
             let a5:Float! = Float(txt_total)
            cell.txt_Addins.text = self.AddIns
           
            let a4:Float! = a5-a3
            cell.txt_payRest.text = StaticData.singleton.historySymbol!+String(format: "%.2f",Float(a4))
            if(StaticData.singleton.isTrack == "0"){
                trackView.alpha = 1
            if(StaticData.singleton.UserAddress == "Pick Up"){
                btn_track.alpha = 0.5
                btn_track.isUserInteractionEnabled = false
                
                
              
            }else{
                btn_track.alpha = 1.0
                btn_track.isUserInteractionEnabled = true
            }
            }else{
                
                trackView.alpha = 0
            }
            if(StaticData.singleton.hotel_accepted == "1"){
                
            }else{
                btn_track.alpha = 0.5
                btn_track.isUserInteractionEnabled = false
            }
           
                
                cell.mPay_lbl.alpha = 0
                cell.txt_payRest.alpha = 0
                cell.pay_view.alpha = 0
                cell.image_lbl.alpha = 0
                cell.mTotal_lbl.text = "Total"
            //}
            
            return cell
        }else{
            
            let cell:CardDetailTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "48thCell") as! CardDetailTableViewCell
            let obj:cartlist = notificaionArray[indexPath.section].listOfcarts[indexPath.row]
            let obj1  = notificaionArray[indexPath.section]
           
            let str:String! = obj1.myquantity+"x "+obj.name1
            cell.subname.text = str+" +"+StaticData.singleton.historySymbol!+obj.price1+""
            
            
            return cell
        }
        
        
    }
    
    
    
    @IBAction func trackNow(_ sender: Any) {
        
        
        
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TrackLocationViewController") as! TrackLocationViewController
        
        self.present(secondVC, animated: true, completion: nil)
    }
    
    
    func alertModule1(title:String,msg:String){
        
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        let alertAction2 = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction!) in
            
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:")!) {
                var urlString = "comgooglemaps://?daddr=\((StaticData.singleton.rider_lat as! NSString).doubleValue),\((StaticData.singleton.rider_lon as! NSString).doubleValue)"
                print(urlString)
                UIApplication.shared.openURL(URL(string: urlString)!)
            }
            else {
                var urlString = "comgooglemaps://?daddr=\((StaticData.singleton.rider_lat as! NSString).doubleValue),\((StaticData.singleton.rider_lon as! NSString).doubleValue)"
                print(urlString)
                UIApplication.shared.openURL(URL(string: urlString)!)
            }
            
            
        })
        
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }

   
    

}
