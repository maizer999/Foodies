//
//  RestaurantDealViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/20/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD

class RestaurantDealViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var myCart:[[String:Any]]? = [[:]]
    
    
    @IBOutlet weak var innerview: UIView!
    
    @IBOutlet weak var txt_desc: UILabel!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableview: UITableView!
    
    
    var refreshControl = UIRefreshControl()
    
    var loadingToggle:String? = "yes"
    
    var status:String? = "active"
    var toggle:String? = "yes"
    
    let defaults = UserDefaults.standard
    
 
    
    var menuItemList:NSMutableArray = []
    var ExtramenuItemList:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(RestuarntsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableview?.addSubview(refreshControl)
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        self.tabBarController?.tabBar.isUserInteractionEnabled = false;
      
            
            //self.RestaurantOrderApi()
        
    }
    
  
    
    
    
    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
        self.RestaurantOrderApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = StaticData.singleton.Rest_name!+" Deals"
        self.RestaurantOrderApi()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    
    func RestaurantOrderApi(){
        
        
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
        
        let url : String = appDelegate.baseUrl+appDelegate.showRestaurantDeals
        let parameter :[String:Any]? = ["lat":defaults.string(forKey: "hostel_lat")!,"long":defaults.string(forKey: "hostel_lon")!,"restaurant_id":StaticData.singleton.Rest_id!]
        print(url)
        print(parameter!)
        
        
        Alamofire.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
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
                    
                    myCountry = (dic["msg"] as? [[String:Any]])!
                    
                    for Dict in myCountry {
                        let myRestaurant = Dict["Deal"] as! NSDictionary
                        let myRestaurant1 = Dict["Restaurant"] as! NSDictionary
                        let myRestaurant2 = myRestaurant1["Currency"] as! NSDictionary
                        let myRestaurant3 = myRestaurant1["Tax"] as! NSDictionary
                        
                        let Dealid = myRestaurant["id"]
                        let des_detail = myRestaurant["description"]
                        var myStringArr = (myRestaurant["starting_time"] as! String).components(separatedBy:" ")
                        let expire_date = myStringArr[0]
                        let Dealname = myRestaurant["name"]
                        let Dealprice = myRestaurant["price"]
                        let restaurant_id = myRestaurant["restaurant_id"]
                        let cover_img = myRestaurant["cover_image"]
                        let img = myRestaurant["image"]
                        let restaurant_name = myRestaurant1["name"]
                        let Deal_Curr = myRestaurant2["symbol"]
                        let Deal_fee = myRestaurant1["delivery_free_range"]
                        let Deal_tax = myRestaurant3["tax"]
                        let promote = myRestaurant["promoted"]
                        let delivery_fee_per_km = myRestaurant3["delivery_fee_per_km"]
                        let min_order_price  = myRestaurant1["min_order_price"]
                        
                        let obj1 = Deal(Dealid:Dealid as! String, restaurant_id:restaurant_id as! String, Dealname:Dealname as! String,Dealprice:Dealprice as! String,expire_date:expire_date as! String,des_detail:des_detail as! String,cover_img:cover_img as! String,img:img as! String,restaurant_name:restaurant_name as! String,Deal_curr:Deal_Curr as! String,Deal_tax:Deal_tax as! String,Deal_fee:Deal_fee as! String,promote:promote as! String,min_order_price:min_order_price as! String, delivery_fee_per_km:delivery_fee_per_km as! String)
                        
                        self.menuItemList.add(obj1)
                    }
                    
                    
                    if(self.menuItemList.count == 0){
                        
                        self.innerview.alpha = 1
                        self.refreshControl.endRefreshing()
                        
                    }else{
                        
                        self.innerview.alpha = 0
                        // self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                        self.toggle = "no"
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
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
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
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:DealTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell60") as! DealTableViewCell
        
        let obj1 = menuItemList[indexPath.row] as! Deal
        
        cell.dTitle.text = obj1.Dealname
        cell.dDescrp.text = obj1.restaurant_name
        
        cell.dPrice.text = obj1.Deal_curr+obj1.Dealprice
        if(obj1.min_order_price == "0.00"){
            cell.txt_MinOrder.text = obj1.Deal_curr+obj1.delivery_fee_per_km+"/km"
            
        }else{
            
            let s:String! = obj1.Deal_curr+obj1.delivery_fee_per_km+"/km- Free over "
            cell.txt_MinOrder.text = s+obj1.Deal_curr+obj1.min_order_price
            
        }
        
        cell.dTime.text = obj1.expire_date
        //cell.htime.text = obj1.Created
        cell.d_img.layer.masksToBounds = false
        cell.d_img.layer.cornerRadius = cell.d_img.frame.height/2
        cell.d_img.clipsToBounds = true
        cell.d_img.sd_setImage(with: URL(string:self.appDelegate.ImagebaseUrl+obj1.img), placeholderImage: UIImage(named: "Unknown"))
        if(obj1.promote == "0"){
            cell.feature_img.alpha = 0
        }else{
            
            cell.feature_img.alpha = 1
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj1 = menuItemList[indexPath.row] as! Deal
        
        StaticData.singleton.detailTitle = obj1.Dealname
        StaticData.singleton.dealId = obj1.Dealid
        StaticData.singleton.detailprice = obj1.Dealprice
        StaticData.singleton.detaildes = obj1.des_detail
        StaticData.singleton.detailimg = self.appDelegate.ImagebaseUrl+obj1.cover_img
        StaticData.singleton.detailrest = obj1.restaurant_name
        StaticData.singleton.dealSymbol = obj1.Deal_curr
        StaticData.singleton.DealFee = obj1.Deal_fee
        StaticData.singleton.DealTax = obj1.Deal_tax
        StaticData.singleton.detailrestID = obj1.restaurant_id
         StaticData.singleton.DealMinOrderprice = obj1.min_order_price
       self.performSegue(withIdentifier:"goRestDeal", sender:self)
        
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
