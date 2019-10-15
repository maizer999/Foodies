//
//  OrderHistoryViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD

class OrderHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //@IBOutlet weak var order_seg: UISegmentedControl!
    
    var myCart:[[String:Any]]? = [[:]]

    @IBOutlet weak var btn_filter: UIBarButtonItem!
    
    @IBOutlet weak var innerview: UIView!
    
    @IBOutlet weak var myView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var current_view: UIView!
    
    @IBOutlet weak var past_view: UIView!
    
     var refreshControl = UIRefreshControl()
    
    var loadingToggle:String? = "yes"
    var isDeal:String? = "no"
    
    var status:String? = "1"
    var toggle:String? = "yes"
    

    @IBOutlet weak var txt_placeholder: UILabel!
    
    
    var menuItemList:NSMutableArray = []
    var ExtramenuItemList:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingToggle = "yes"
        self.status = "1"
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(RestuarntsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableview?.addSubview(refreshControl)
     
        
        
      
       appDelegate.showActivityIndicatory(uiView:self.view)
        self.tabBarController?.tabBar.isUserInteractionEnabled = false;
        
    }
    
    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
        self.OrderApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.title = "History"
       loadingToggle = "yes"
        self.status = "1"
        if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            
            txt_placeholder.text = "you have not placed any order yet. Place your order first"
        }else{
            
            txt_placeholder.text = "Please login to check your order history"
        }
        
        self.OrderApi()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func segmentMethod(_ sender: Any) {
//        let seg:Int! = (sender as AnyObject).selectedSegmentIndex
//        if seg == 0 {
//        self.isDeal = "no"
//            StaticData.singleton.isDeal = "no"
//            self.OrderApi()
//        }else{
//            self.isDeal = "yes"
//            StaticData.singleton.isDeal = "yes"
//            self.OrderApi()
//        }
//
//    }
    

    func OrderApi(){
        
        
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

        let url : String = appDelegate.baseUrl+appDelegate.showOrders
        let parameter :[String:Any]?
        if(self.isDeal == "no"){
       parameter =  ["user_id":UserDefaults.standard.string(forKey: "uid")!,"status":self.status!]
        }else{
            
         parameter =    ["user_id":UserDefaults.standard.string(forKey: "uid")!,"status":self.status!,"deal":"deal"]
        }
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
              
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                self.tabBarController?.tabBar.isUserInteractionEnabled = true;
                let json  = value
           
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                var myCountry:[[String:Any]]
                if(String(describing: code) == "200"){
                    self.menuItemList = []
                    self.ExtramenuItemList = []
                    
//                    if(self.status == "active"){
                    
                        myCountry = (dic["msg"] as? [[String:Any]])!
                        
                        
                        
//                    }else{
//
//                        myCountry = (dic["CompletedOrders"] as? [[String:Any]])!
//
//
//                    }
                    
                    
            
                    for Dict in myCountry {
                       let myRestaurant = Dict["Order"] as! NSDictionary
                        let myRestaurant1 = myRestaurant["Currency"] as! NSDictionary
                        let myRestaurant3 = myRestaurant["Rider"] as! NSDictionary
                       
                          let myRestaurant2 = myRestaurant["OrderMenuItem"] as! NSArray
                        
                        if(myRestaurant2.count != 0){
                            let dic2 = myRestaurant2[0] as! NSDictionary
                            print(dic2)
                            let Menuid = dic2["id"]
                            let Menuname = dic2["name"]
                            let Menuquantity = dic2["quantity"]
                            let Menuprice = myRestaurant["price"]
                            let hotel_accepted = myRestaurant["delivery"]
                            let Orderid = dic2["order_id"]
                            let deal_id = myRestaurant["deal_id"]
                            let Created = myRestaurant["created"]
                            let orderCurrency = myRestaurant1["symbol"]
                            var Instruction:String? = ""
                            if let latestValue = myRestaurant["name"]as? String {
                                Instruction = latestValue
                            }else{
                                
                                 Instruction = ""
                            }
                       
                        let RiderLat = myRestaurant3["lat"]
                        let RiderLon = myRestaurant3["long"]
                        let first = myRestaurant3["first_name"] as? String
                        let last = myRestaurant3["last_name"] as? String
                        let RiderName = first!+" "+last!
                        let RiderPhone = myRestaurant3["phone"]
                            let RestaurantMenuExtraItem = dic2["OrderMenuExtraItem"]  as! NSArray
                           if( RestaurantMenuExtraItem.count == 0){
                            
                            let obj = Order(Menuid:Menuid as! String, Menuname:Menuname as! String, Menuquantity:Menuquantity as! String,Menuprice:Menuprice as! String,Orderid:Orderid as! String,Created:Created as! String,Instruction:Instruction as! String, ExtraItemName:"" as! String, orderCurrency:orderCurrency as! String,RiderLat:RiderLat as! String,RiderLon:RiderLon as! String,RiderName:RiderName as! String,RiderPhone:RiderPhone as! String,hotel_accepted: hotel_accepted as! String,deal_id:deal_id as! String)
                            self.menuItemList.add(obj)
                           }else{
                                let dic3 = RestaurantMenuExtraItem[0] as! [String:Any]
                               // let Extraid = dic3["id"]
                                let ExtraItemName = dic3["name"]
//                                let Extraquantity = dic3["quantity"]
//                                let Extraprice = dic3["price"]
                                
                                let obj = Order(Menuid:Menuid as! String, Menuname:Menuname as! String, Menuquantity:Menuquantity as! String,Menuprice:Menuprice as! String,Orderid:Orderid as! String,Created:Created as! String,Instruction:Instruction as! String, ExtraItemName:"" as! String, orderCurrency:orderCurrency as! String,RiderLat:RiderLat as! String,RiderLon:RiderLon as! String,RiderName:RiderName as! String,RiderPhone:RiderPhone as! String,hotel_accepted: hotel_accepted as! String,deal_id:deal_id as! String)
                                    self.menuItemList.add(obj)
                            
                            }
                            
                        }
                        
                       
                    }
                    
                    print(self.menuItemList.count)
                    
                    if(self.menuItemList.count == 0){
                        
                        self.innerview.alpha = 1
                         self.refreshControl.endRefreshing()
                       
                      
                    }else{
                        
                         self.innerview.alpha = 0
                       // self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                        //self.toggle = "no"
                         self.refreshControl.endRefreshing()
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
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
                 self.tabBarController?.tabBar.isUserInteractionEnabled = true;

                print(error)
                if(error.localizedDescription == "The network connection was lost."){
                    self.OrderApi()
                }else{
                    
                    self.alertModule(title:"Error",msg:error.localizedDescription)
                }
                //self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    @objc func loaded()
    {
        Loader.removeLoaderFrom(tableview)
    }
    
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
           return menuItemList.count
   
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 98
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            
            let cell:HistoryTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell7") as! HistoryTableViewCell
            
            let obj1 = menuItemList[indexPath.row] as! Order
        
            cell.htitle.text = obj1.Menuname
            cell.hdescription.text = obj1.Instruction
//            cell.rPrice.text = "x"+obj1.Menuquantity+" "+obj1.ExtraItemName
            cell.horderNO.text = "Order# "+obj1.Orderid
            cell.hprice.text = obj1.orderCurrency+obj1.Menuprice
            let fullNameArr = obj1.Created?.components(separatedBy: " ")
            cell.htime.text = fullNameArr![0]
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "HH:mm:ss"
            let date = dateFormatter1.date(from:fullNameArr![1])
            dateFormatter1.dateFormat = "hh:mm a"
            cell.hdate.text = dateFormatter1.string(from:date!)
        
        if(obj1.hotel_accepted == "1"){
            cell.btn_track.alpha = 1.0
            cell.btn_track.isUserInteractionEnabled = true
       
        }else{
            
            cell.btn_track.alpha = 0.5
            cell.btn_track.isUserInteractionEnabled = false
        }
        
        if(status == "1"){
            
        }else{
            
            cell.btn_track.alpha = 0.5
            cell.btn_track.isUserInteractionEnabled = false
        }
        
      
        if(obj1.deal_id == "0"){
            cell.img_deal.alpha = 0
            
        }else{
            cell.img_deal.alpha = 1
          
        }
            //cell.htime.text = self.timeCalculate(dateString: obj1.Created)
            //cell.htime.text = obj1.Created
    
        cell.btn_track.tag = indexPath.row
        cell.btn_track.addTarget(self, action: #selector(OrderHistoryViewController.pressPlay(_:)), for: .touchUpInside)
     
            
            return cell
      
    }
    
    @objc func pressPlay(_ sender: UIButton){
        
        
        let buttonTag = sender.tag
        let obj = menuItemList[buttonTag] as! Order
        StaticData.singleton.rider_lat = obj.RiderLat
        StaticData.singleton.rider_lon = obj.RiderLat
        StaticData.singleton.map_name = obj.RiderName
        StaticData.singleton.map_phone = obj.RiderPhone
        StaticData.singleton.OrderId = obj.Orderid
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TrackLocationViewController") as! TrackLocationViewController
        
        
        
        self.present(secondVC, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj1 = menuItemList[indexPath.row] as! Order
        
        print(obj1.Orderid)
        StaticData.singleton.OrderName = obj1.Menuname
        StaticData.singleton.OrderId = obj1.Orderid
        StaticData.singleton.historySymbol = obj1.orderCurrency
        StaticData.singleton.hotel_accepted = status
        StaticData.singleton.isTrack = "0"
        
        self.performSegue(withIdentifier:"TrackOrder", sender:self)

    }
    
   
    
 
    
    @IBAction func filter(_ sender: Any) {
    
        if(isDeal == "no"){
        let sheet = UIAlertController(title: "Orders Filter", message:nil, preferredStyle: .actionSheet) // Initialize action sheet type
        
        let Bank = UIAlertAction(title: "Current Orders", style: .default, handler: { action in
            // Presents picker
            
            self.status = "1"
            self.loadingToggle = "yes"
            self.OrderApi()
            
        })
        
        let MRS = UIAlertAction(title: "Past Orders", style: .default, handler: { action in
            // Presents picker
            
            self.status = "2"
            self.loadingToggle = "yes"     
            self.OrderApi()
            
        })
            
        let cancelled = UIAlertAction(title: "Cancelled Orders", style: .default, handler: { action in
                // Presents picker
                
                self.status = "4"
                self.loadingToggle = "yes"
                self.OrderApi()
                
            })
       
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            // Presents picker
            sheet.hidesBottomBarWhenPushed = true
        })
        
        // Add actions
        sheet.addAction(Bank)
        sheet.addAction(MRS)
        sheet.addAction(cancelled)
        sheet.addAction(Cancel)
            if ( UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                if let popoverPresentationController = sheet.popoverPresentationController {
                    popoverPresentationController.sourceView = self.view
                    popoverPresentationController.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0,y: self.view.bounds.size.height / 2.0, width:1.0, height:1.0)
                    present(sheet, animated: true, completion: nil)
                }
            }else{
                present(sheet, animated: true, completion: nil)
            }
        }else{
            let sheet = UIAlertController(title: "Deals Filter", message:nil, preferredStyle: .actionSheet) // Initialize action sheet type
            
            let Bank = UIAlertAction(title: "Current Deals", style: .default, handler: { action in
                // Presents picker
                
                self.status = "1"
                self.loadingToggle = "yes"
                self.OrderApi()
                
            })
            
            let MRS = UIAlertAction(title: "Past Deals", style: .default, handler: { action in
                // Presents picker
                
                self.status = "2"
                self.loadingToggle = "yes"
                self.OrderApi()
                
            })
            let cancelled = UIAlertAction(title: "Cancelled Orders", style: .default, handler: { action in
                // Presents picker
                
                self.status = "4"
                self.loadingToggle = "yes"
                self.OrderApi()
                
            })
            
            let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                // Presents picker
                sheet.hidesBottomBarWhenPushed = true
            })
           
            // Add actions
            sheet.addAction(Bank)
            sheet.addAction(MRS)
            sheet.addAction(cancelled)
            sheet.addAction(Cancel)
            if ( UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                if let popoverPresentationController = sheet.popoverPresentationController {
                    popoverPresentationController.sourceView = self.view
                    popoverPresentationController.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0,y: self.view.bounds.size.height / 2.0, width:1.0, height:1.0)
                    present(sheet, animated: true, completion: nil)
                }
            }else{
                present(sheet, animated: true, completion: nil)
            }
            
        }
    
    }
  
    func timeCalculate(dateString:String) -> String{
        
        let calendar = Calendar.current
        
        let firstDate  = NSDate() // Current date
        // Get input(date) from textfield
        
        let isoDate = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:isoDate)!
   
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let secondDate = calendar.date(from:components)
    
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < secondDate! {
            let diff = Calendar.current.dateComponents([.second], from: secondDate!, to: Date()).second ?? 0
            if(diff == 1){
                return "\(diff) second ago"
            }else{
            return "\(diff) seconds ago"
            }
        } else if hourAgo < secondDate! {
            let diff = Calendar.current.dateComponents([.minute], from: secondDate!, to: Date()).minute ?? 0
            if(diff == 1){
            return "\(diff) minute ago"
            }else{
              return "\(diff) minutes ago"
                
            }
        } else if dayAgo < secondDate! {
            let diff = Calendar.current.dateComponents([.hour], from: secondDate!, to: Date()).hour ?? 0
            if(diff == 1){
                return "\(diff) hour ago"
            }else{
                return "\(diff) hours ago"
                
            }
            
        } else if weekAgo < secondDate! {
            let diff = Calendar.current.dateComponents([.day], from: secondDate!, to: Date()).day ?? 0
            if(diff == 1){
               return "\(diff) day ago"
            }else{
                return "\(diff) days ago"
                
            }
            
        }else{
        let diff = Calendar.current.dateComponents([.weekOfYear], from: secondDate!, to: Date()).weekOfYear ?? 0
            if(diff == 1){
                return "\(diff) week ago"
            }else{
               return "\(diff) weeks ago"
                
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
}
