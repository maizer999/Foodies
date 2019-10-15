//
//  JobTimeViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/6/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON
import DatePickerDialog

class JobTimeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var orders:NSMutableArray = []
    var myString:String! = ""
    var selectedProgram:Riderorder?
    
    @IBOutlet weak var innerview: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        myString = formatter.string(from: Date())
        
       
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.HistoryOrderApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func HistoryOrderApi(){
        
        orders = []
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.showRiderOrdersBasedOnDate
        // < [!] Expected declaration
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"date":self.myString]
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
                let json  = value
                //activityIndicatorView.stopAnimating()
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                    if(myCountry?.count != 0){
                        
                        for Dict in myCountry! {
                            
                            let Order = Dict["Order"] as! [String:Any]
                            let orderid = Order["id"] as! String
                            let created = Order["created"] as! String
                            let price = Order["price"] as! String
                            let userinfo = Order["UserInfo"] as! [String:String]
                            let first_name = userinfo["first_name"] as! String
                            let last_name = userinfo["last_name"] as! String
                            let phone = userinfo["phone"] as! String
                            let user_id = userinfo["user_id"] as! String
                            var latitude:String! = ""
                            var longitude:String! = ""
                            var a:String! = ""
                            var b:String! = ""
                            var address:String! = ""
                            var User_Instruction:String! = ""
                            var riderIns:String! = ""
                            
                            if let Addressinfo = Order["Address"] as? [String:String]{
                                latitude = Addressinfo["lat"] as! String
                                 longitude = Addressinfo["long"] as! String
                                 a = Addressinfo["street"] as! String+" ,"+Addressinfo["city"]! as! String
                                riderIns = Addressinfo["instructions"] as! String
                            b = Addressinfo["country"]!
                                address = a+" ,"+b as! String
                                User_Instruction = Addressinfo["instructions"] as! String
                                
                            }else{
                                
                                address = "Pick Up"
                                
                            }
                            
                            
                            let Restaurant = Order["Restaurant"] as! [String:Any]
                            let taxFree = Restaurant["tax_free"] as! String
                            let taxVlaue = Order["tax"] as! String
                            let Currency = Restaurant["Currency"] as! NSDictionary
                            let symbol = Currency["symbol"] as! String
                            let Restlocation = Restaurant["RestaurantLocation"] as! [String:String]
                            let a1:String! = Restlocation["street"]! as! String+" ,"+Restlocation["city"]! as! String
                            let b1:String! = Restlocation["country"]! as! String
                            
                            let Rest_address = a1+" ,"+b1
                            let Rest_latitute = Restlocation["lat"] as! String
                            let Rest_longitude = Restlocation["long"] as! String
                            let rest_name = Restaurant["name"] as! String
                            let rest_salogan = Restaurant["slogan"] as! String
                            let rest_phone = Restaurant["phone"] as! String
                            let cod = Order["cod"] as! String
                            let fee = Order["delivery_fee"] as! String
                            let sub_total = Order["sub_total"] as! String
                            let per = Order["tax"] as! String
                            var colltime:String! = ""
                            var deltime:String! = ""
                            let riderTip =  Order["rider_tip"] as! String
                            if let dictionary:NSDictionary = Dict["RiderOrder"] as? NSDictionary{
                                
                                
                                let order7 = dictionary["EstimateReachingTime"] as! NSDictionary
                                colltime = order7["estimate_collection_time"] as! String
                                deltime = order7["estimate_delivery_time"] as! String
                                
                                
                            }
                            
                            
                           let obj = Riderorder(orderid:orderid, created:created, price:price,last_name: last_name,first_name: first_name, phone: phone, user_id:user_id,address: address,rest_name: rest_name, rest_salogan:rest_salogan,rest_phone:rest_phone,latitude:latitude,longitude:longitude,Rest_address:Rest_address,Rest_latitute:Rest_latitute,Rest_longitude:Rest_longitude,User_Instruction:User_Instruction,cod:cod,symbol:symbol,fee:fee,per:per,sub_total:sub_total,colltime:colltime,deltime:deltime,riderTip:riderTip,riderIns:riderIns,taxFree:taxFree,taxValue:taxVlaue)
                            
                            self.orders.add(obj)
                            
                        }
                    }else{
                        
                        self.orders = []
                    }
                    
                    
                    if(self.orders.count == 0){
                        
                        self.innerview.alpha = 1
                    }else{
                        self.innerview.alpha = 0
                        self.tableview.reloadData()
                    }
                   
                }else{
                    
                    
                    //self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
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
        return orders.count
    }
    
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            
            return 90
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell:TodayJobCell = tableview.dequeueReusableCell(withIdentifier: "45th") as! TodayJobCell
        let obj = orders[indexPath.row] as! Riderorder
        
        cell.rider_name.text =  obj.Rest_address
        let myString:String = obj.created
        var myStringArr = myString.components(separatedBy:" ")
         let time = myStringArr[1]
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let fullDate = dateFormatter.date(from: time)

        dateFormatter.dateFormat = "hh:mm a"
        
        let time2 = dateFormatter.string(from: fullDate!)
        cell.rider_time.text = time2
        
        cell.rider_order.text = "Order #"+obj.orderid
        cell.hotel_name.text = obj.rest_name
        if(obj.cod == "0"){
            cell.rider_payment.text = "Credit Card"
        }else{

            cell.rider_payment.text = "Cash On Delivery"
        }
        
        cell.rider_price.text = obj.symbol+obj.price
            
        return cell
      
        
        
    }
    
    @IBAction func filter(_ sender: Any) {
        
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode:.date) {
            (backDate) -> Void in
            if let dt = backDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                self.myString = dateFormatter.string(from:dt)
                
                self.HistoryOrderApi()
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            selectedProgram = orders[indexPath.row] as! Riderorder

            // Create an instance of PlayerTableViewController and pass the variable
        
            StaticData.singleton.OrderId = selectedProgram?.orderid
            StaticData.singleton.currSymbol = selectedProgram?.symbol

            StaticData.singleton.hideRiderBtn = "yes"

            self.performSegue(withIdentifier:"showorder2", sender:nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showorder2") {
            StaticData.singleton.showOrderToggle = "YES"
            let vc = segue.destination as! jobs2ViewController
            //vc.myDict =  selectedProgram
        }
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
