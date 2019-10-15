//
//  DetailCartViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
import Firebase
import FirebaseDatabase
import Foundation
import SystemConfiguration


class DetailCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet var titleName: UILabel!
    
    @IBOutlet weak var blurview: UIView!
    @IBOutlet weak var inner_label: UILabel!
    
    @IBOutlet weak var inner_img: UIImageView!
    
    @IBOutlet weak var inner2_label: UILabel!
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var txt_codePromo: UITextField!
    
    var localPromo:String! = ""
    
    
    
    @IBOutlet weak var txt_amount: UITextField!
    
    
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var btn_done: UIButton!
    @IBOutlet weak var tip_img: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var promo_view: UIView!
    var currency:String = ""
    var isPick:String = "YES"
    var delivery:String = "1"
    var isTip:String = "NO"
    var rider_tip:String = "0"
    var Minorderprice:String = "0"
    var myTax:String = ""
    var myFee:String = "0"
    var selectIndex:Int! = 0
    var subtotal:Float = 0.0
    var taxvalue:Float = 0.0
    var deleteIndex:Int = 0
    var preivousTip:String! = ""
    
    

    
    var childRef1 = FIRDatabase.database().reference().child("Cart");
    @IBOutlet var innerView: UIView!
    
    var menuItemList:NSMutableArray = []
    var ExtramenuItemList:NSMutableArray = []
    
    @IBOutlet weak var promoimg: UIImageView!
    
    @IBOutlet weak var clear_btn: UIBarButtonItem!
    
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var tableview: UITableView!
    
    var promr:String! = ""
    var coupan_id:String! = ""
    var Instruction:String! = ""
    var paramTotal:String! = ""
    var paramSubTotal:String! = ""
    var paramTax:String! = ""
    
    
    var para :[[String:Any]] = [["":""]]
    
    var para1:NSArray = []
    
    var extraunitprice:Float! = 0.0
    var totalPrice:Float! = 0.0
    var totalInvoce:Float! = 0.0
    var quan:Float! = 0.0
    
     var notificaionArray = [Cart]()
    
    var prodArray:Array<Any>?
    var extra:[String:Any]? = ["":""]
    @IBOutlet var myView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame  = self.view.frame
        blurview.addSubview(blurredEffectView)
    
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        let font = UIFont(name: "Verdana", size:15)
        clear_btn.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!], for: .normal)
        
        tip_img.layer.masksToBounds = false
        tip_img.layer.cornerRadius = tip_img.frame.height/2
        tip_img.clipsToBounds = true
        promoimg.layer.masksToBounds = false
        promoimg.layer.cornerRadius = promoimg.frame.height/2
        promoimg.clipsToBounds = true
        
        self.tipView.layer.borderWidth = 1
        self.tipView.layer.borderColor =  UIColor.init(red:221/255 , green:221/255  , blue:221/255  , alpha: 1.0).cgColor
        self.promo_view.layer.borderWidth = 1
        self.promo_view.layer.borderColor =  UIColor.init(red:221/255 , green:221/255  , blue:221/255  , alpha: 1.0).cgColor
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        //rider_tip = "0"
        clear_btn.tintColor = UIColor.clear
        let view1 = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:20))
        view1.backgroundColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        self.navigationController?.view.addSubview(view1)
        
       tableview.setContentOffset(CGPoint.zero, animated: true)
        self.inner_img.image =
            UIImage(named:"2")
        self.inner_label.text = "Whoops!"
        
       
        self.LoadCartDetail()
        
      
    }
    
   
    
   
    
    @IBAction func cancel(_ sender: Any) {
//        self.rider_tip = "0"
        //isTip = ""
        self.tipView.alpha = 0
        let view1 = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:20))
        view1.backgroundColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        self.navigationController?.view.addSubview(view1)
        self.blurview.alpha = 0
        //self.tableview.reloadData()
        
    }
    
    @IBAction func Done(_ sender: Any) {
        self.rider_tip = txt_amount.text!
        if(self.rider_tip != self.preivousTip){
        
        let view1 = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:20))
        view1.backgroundColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        self.navigationController?.view.addSubview(view1)
        if(txt_amount.text!.isEmpty){
            
            self.alertModule(title:"Error", msg:"Please enter Tip Amount.")
        }else{
            
            print(self.rider_tip)
            isTip = "YES"
            self.blurview.alpha = 0
            self.tipView.alpha = 0
            self.preivousTip = self.rider_tip
        }
        self.LoadCartDetail()
        //self.tableview.reloadData()
        }else{
            self.blurview.alpha = 0
            self.tipView.alpha = 0
        }
    }
   
    
    
    func LoadCartDetail(){
        self.subtotal = 0.0
        self.taxvalue = 0.0
        self.extraunitprice = 0.0
        self.totalPrice = 0.0
        self.totalInvoce = 0.0
        self.quan = 0.0
        totalInvoce = 0.0
        let isValid:Bool = self.isInternetAvailable()
        
        if(isValid){
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}

        if(UserDefaults.standard.string(forKey:"udid") == nil){
            
            UserDefaults.standard.set("abc", forKey:"udid")
        }
        
        print(UserDefaults.standard.string(forKey:"udid")!)
        childRef1.child(UserDefaults.standard.string(forKey:"udid")!).observeSingleEvent(of:.value, with: { (snapshot) in
         self.notificaionArray = []
            self.para1 = []
             self.para = []
            
            var tax:Float = 0.0
            var fee:Float = 0.0

            if snapshot.childrenCount > 0 {
                for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    let artistObject = artists.value as? [String: AnyObject]
                    print(artistObject!)
                    var finalArray:[String:Any]? = ["":""]
                    let tempMenuObj = Cart()
                    print(artistObject?["mname"] as! String)
                    tempMenuObj.key1 = artistObject?["key"] as! String
                    tempMenuObj.id1 = artistObject?["mID"] as! String
                    tempMenuObj.name = artistObject?["mname"] as! String
                    tempMenuObj.price = artistObject?["mprice"] as! String
                    tempMenuObj.myquantity = artistObject?["mquantity"] as! String
                    tempMenuObj.myCurrency = artistObject?["mCurrency"] as! String
                    tempMenuObj.myFee = artistObject?["mFee"] as! String
                    self.Minorderprice = artistObject?["mMinPrice"] as! String
                    tempMenuObj.Minprice = artistObject?["mMinPrice"] as! String
                    tempMenuObj.myRestID = artistObject?["RestID"] as! String
                    tempMenuObj.myDesc = artistObject?["mDesc"] as! String
                    tempMenuObj.myTax = artistObject?["mTax"] as! String
                   self.myFee = artistObject?["mFee"] as! String
                   self.myTax = artistObject?["mTax"] as! String
                    tax = Float(artistObject?["mTax"] as! String)!
                    fee = Float(artistObject?["mFee"] as! String)!
                    self.currency = artistObject?["mCurrency"] as! String
                    self.Instruction = artistObject?["Instruction"] as! String
                    self.totalPrice = Float(artistObject?["mprice"] as! String)
                    self.quan = Float(artistObject?["mquantity"] as! String)
                    self.totalPrice = self.totalPrice*self.quan
                    
                   // self.para.append(param1!)
                   
                    if(artistObject?["ExtraItem"] != nil){
                        
                        self.para1 = artistObject?["ExtraItem"] as! NSArray
                        
                        self.prodArray = []
                        for i in 0...self.para1.count-1{
                        
                            var tempProductList = cartlist()
                            let prod:NSMutableDictionary = NSMutableDictionary()
                           
                            let dic1 = self.para1[i] as! [String:Any]
                            
                            let param:[String:Any]? = ["menu_extra_item_name":dic1["menu_extra_item_name"] as! String,"menu_extra_item_price":dic1["menu_extra_item_price"] as! String,"menu_extra_item_quantity":artistObject?["mquantity"] as! String]
                           
                            
                            //self.extra![dic1]
                            //print(self.extra)
                           
                            tempProductList.name1 = dic1["menu_extra_item_name"] as! String
                            tempProductList.price1 = dic1["menu_extra_item_price"] as! String
                            tempProductList.quantity1 = artistObject?["mquantity"] as! String
                           
                            self.extraunitprice = Float(dic1["menu_extra_item_price"] as! String)
                            let myquantity:Float = self.quan*self.extraunitprice
                            print(myquantity)
                            self.totalPrice = self.totalPrice+myquantity
                            tempMenuObj.listOfcarts.append(tempProductList)
                           
                            self.prodArray?.append(param!)
                          
                      
                            
                        }
                    
                    }
                   
                     var param1:[String:Any]? = ["menu_item_name":artistObject?["mname"] as! String,"menu_item_price":artistObject?["mprice"] as! String,"menu_item_quantity":artistObject?["mquantity"] as! String,"menu_extra_item":self.prodArray]
                    self.para.append(param1!)
                    print(self.para)
                    print(self.totalPrice)
                    print(self.totalInvoce)
                    self.totalInvoce = self.totalInvoce+self.totalPrice
                   
                    self.notificaionArray.append(tempMenuObj)
                }
                
                
                
            }else{
                
                self.tabBarController?.tabBar.items?[3].badgeValue = nil
            }
            
            self.subtotal = self.totalInvoce
            let tax1:Float = (self.subtotal/100)*tax
            self.taxvalue = (self.subtotal/100)*tax
            self.totalInvoce = self.subtotal+tax1
            
            self.view.isUserInteractionEnabled = true
            KRProgressHUD.dismiss {
                print("dismiss() completion handler.")
            }
            if(self.notificaionArray.count == 0){
               
                self.innerView.isHidden = false
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            }else{
               
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                self.innerView.isHidden = true
                print(self.notificaionArray.count)
                self.tableview.reloadData()
            }
           
            
        })
            
        }else{
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
            self.innerView.isHidden = false
           self.alertModule(title:"Error", msg:"The Internet connection appears to be offline.")
            
        }
        
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addpayment(_ sender: Any) {
        
        if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            
            let LoginVC:PaymentMethodPresent =  (storyboard!.instantiateViewController(withIdentifier: "PaymentMethodPresent") as? PaymentMethodPresent)!
            self.present(LoginVC, animated: true, completion: nil)
        }else{
            
           self.performSegue(withIdentifier:"backLogin", sender: self)
        }
    
    }
    
    @IBAction func addaddress(_ sender: Any) {
    
    }
    
    @IBAction func checkout(_ sender: Any) {
        
        let indexPath = IndexPath(row:0, section:notificaionArray.count)
        let cell = tableview.cellForRow(at: indexPath) as! CardDetail2TableCell
        if(self.delivery == ""){
            
            self.alertModule(title:"Error", msg:"Please select either Delivery or Pickup.")
        }else
        if(cell.txt_payment.text!.isEmpty){
            
            self.alertModule(title:"Error", msg:"Please enter payment method.")
        }else if(cell.txt_address.text!.isEmpty){
            
            self.alertModule(title:"Error", msg:"Please enter add delivery address.")
        }else if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            
            self.CheckoutApi()
            
        }else{
            
            self.performSegue(withIdentifier:"backLogin", sender: self)
        }
    }
    
    
    @IBAction func clear(_ sender: Any) {
        
        innerView.isHidden = false
       self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        UserDefaults.standard.set(nil,forKey: "dict")
        self.menuItemList = []
        self.self.ExtramenuItemList = []
        
        let val = FIRDatabase.database().reference().child("Cart").child(UserDefaults.standard.string(forKey:"udid")!)
        val.removeValue(completionBlock: { (error, refer) in
            if error != nil {
                print(error)
            } else {
                print(refer)
                StaticData.singleton.AccountID = ""
                StaticData.singleton.AddressID = ""
                StaticData.singleton.cardnumber = ""
                StaticData.singleton.cardAddress = ""
                StaticData.singleton.cart_addressFee = ""
                StaticData.singleton.cart_addresstotal = ""
                self.isTip = "NO"
                self.txt_amount.text = ""
                self.rider_tip  = "0"
                self.tabBarController?.tabBar.items?[3].badgeValue = nil
                print("Child Removed Correctly")
            }
        })
    }
    
    @IBAction func dissmiss(_ sender: Any) {
        
        self.dismiss(animated:true, completion:nil)
    }
    
    func CheckoutApi(){
        
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let indexPath = IndexPath(row:0, section:notificaionArray.count)
        let cell = tableview.cellForRow(at: indexPath) as! CardDetail2TableCell
        let url : String = appDelegate.baseUrl+appDelegate.placeOrder
     // < [!] Expected declaration
        var parameter :[String:Any]? = ["":""]
        print(paramTotal)
//        if(self.rider_tip == "0"){
//            
//            let a1:Float! = Float(self.rider_tip)
//            let a2:Float! = Float(self.paramTotal)
//            let a3:Float! = a2-a1
//            paramTotal = String(format: "%.2f",Float(a3))
//        }else{
//            
//            let a1:Float! = Float(self.rider_tip)
//            let a2:Float! = Float(self.paramTotal)
//            let a3:Float! = a1+a2
//            paramTotal = String(format: "%.2f",Float(a3))
//        }
        
        if(delivery == "0"){
            
            self.myFee = "0.00"
            self.rider_tip = "0.00"
        }
        
        var ver:String! = ""
   
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            ver = version
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        if(StaticData.singleton.AccountID == "cod"){
            parameter  = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"price":paramTotal,"sub_total":paramSubTotal,"tax":paramTax,"quantity":String(self.quan),"payment_id":"0","address_id":StaticData.singleton.AddressID!,"menu_item":self.para,"restaurant_id":UserDefaults.standard.string(forKey:"Rest_id")!,"instructions":self.Instruction,"cod":"1","coupon_id":self.coupan_id,"order_time":result,"delivery_fee":self.myFee,"delivery":self.delivery,"rider_tip":self.rider_tip,"device":"iOS","version":ver!]
        }else{
            
            parameter  = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"price":paramTotal,"sub_total":paramSubTotal,"tax":paramTax,"quantity":String(self.quan),"payment_id":StaticData.singleton.AccountID!,"address_id":StaticData.singleton.AddressID!,"menu_item":self.para,"restaurant_id":UserDefaults.standard.string(forKey:"Rest_id")!,"instructions":self.Instruction,"cod":"0","coupon_id":self.coupan_id,"order_time":result,"delivery_fee":self.myFee,"delivery":self.delivery,"rider_tip":self.rider_tip,"device":"iOS","version":ver!]
        }
        
    //}
        
        
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                let json  = value
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    self.txt_amount.text = ""
                    StaticData.singleton.AccountID = ""
                    StaticData.singleton.AddressID = ""
                    StaticData.singleton.cardnumber = ""
                    
                    StaticData.singleton.cardAddress = ""
                    StaticData.singleton.cart_addressFee = ""
                     StaticData.singleton.cart_addresstotal = ""
                   self.rider_tip  = "0"
                   let val = FIRDatabase.database().reference().child("Cart").child(UserDefaults.standard.string(forKey:"udid")!)
                   val.removeValue(completionBlock: { (error, refer) in
                        if error != nil {
                            print(error)
                        } else {
                            print(refer)
                            print("Child Removed Correctly")
                        }
                    })
                    
                    //self.alertModule(title:"Success",msg:dic["msg"] as! String)
                    self.inner_img.image =
                        UIImage(named:"5")
                    self.isTip = "NO"
                    self.inner_label.text = "Order Completed"
                    self.innerView.isHidden = false
                    self.notificaionArray = []
                    let dictionar:NSMutableDictionary = ["0":"0"]
                    UserDefaults.standard.set(nil,forKey: "dict")
                    self.menuItemList = []
                    self.self.ExtramenuItemList = []
                   self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
                    self.tabBarController?.tabBar.items?[3].badgeValue = nil
                    print(UserDefaults.standard.string(forKey:"Rest_id")!)
                    self.tabBarController?.selectedIndex = 2
                    
                  
                    
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
    
    
    func addCoupanApi(){
       
        //appDelegate.showActivityIndicatory(uiView: self.view)
        
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        self.view.isUserInteractionEnabled = false
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.verifyCoupon
     
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"coupon_code":promr,"restaurant_id":UserDefaults.standard.string(forKey:"Rest_id")!,"subtotal":String(self.subtotal)]
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
                    self.txt_codePromo.text = ""
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        let indexPath = IndexPath(row: 0, section:self.notificaionArray.count)
                        let cell = self.tableview.cellForRow(at: indexPath) as! CardDetail2TableCell
                        let myAddress = Dict["RestaurantCoupon"] as! [String:String]
                        let discount = myAddress["discount"] as! String
                        self.coupan_id = myAddress["id"] as! String
                        print(self.totalInvoce)
                        let amount:Float = self.subtotal
                        let amount1 = Float(discount)
                        let amount2 = amount/100*amount1!
                        let amount3 = Float(self.totalInvoce) - amount2
                        self.paramSubTotal = String(format: "%.2f",Float(amount3))
                        cell.txt_promo.text = self.currency+String(format: "%.2f",Float(amount2))+" "+"("+discount+"%"+")"
                        self.localPromo = self.currency+String(format: "%.2f",Float(amount2))+" "+"("+discount+"%"+")"
                        cell.discount_per.text = "("+discount+"%"+")"
                        cell.discount_txt.text =  self.currency+String(format: "%.2f",Float(amount2))
                        
                        //self.tableview.reloadData()
                        //cell.subtotal.text = self.currency+String(format: "%.2f",Float(amount3))
                        
                        self.paramTotal = String(format: "%.2f",Float(amount3))
                        cell.total.text = self.currency+String(format: "%.2f",Float(amount3))
                        
                    }
                    
                
          
                    
                }else{
                    
                    self.txt_codePromo.text = ""
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                self.txt_codePromo.text = ""
                
            }
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return notificaionArray.count+1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == notificaionArray.count){
            
            return 1
        }else{
        return notificaionArray[section].listOfcarts.count  
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

            return 473

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
        let headerLabel = UILabel(frame: CGRect(x:30, y:13, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        let headerLabel2:UILabel
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            headerLabel2 = UILabel(frame: CGRect(x:670, y:13, width:
                160 , height:20))
        }else{
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
        }
       
        headerLabel2.textAlignment = .left
       
        headerLabel.font = UIFont.systemFont(ofSize:14, weight: UIFont.Weight.regular)
        headerLabel.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
        headerLabel2.font = UIFont.systemFont(ofSize:14, weight: UIFont.Weight.regular)
        headerLabel2.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
        headerLabel2.textAlignment = .left
        
//        btn.addTarget(self, action: #selector(buttonAction), forControlEvents: .touchUpInside)
        if section < notificaionArray.count {
            
            let obj = notificaionArray[section]
            let img:UIImageView = UIImageView(frame: CGRect(x:15, y:17, width:10, height:10))
//            let btn: UIButton = UIButton(frame: CGRect(x:0, y:0, width:25, height:tableView.bounds.size.height))
//            btn.tag = section
//            btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            let btn_edit = UIButton(frame: CGRect(x:0, y:0, width:
                tableview.frame.size.width, height: tableView.bounds .size.height))
            btn_edit.tag = section
            btn_edit.addTarget(self, action: #selector(Edit), for: .touchUpInside)
            img.image = UIImage(named: "Close-1")
            headerView.addSubview(img)
            //headerView.addSubview(btn)
             headerView.addSubview(btn_edit)
            headerLabel.text = obj.name+" x"+obj.myquantity
            headerLabel2.text = currency+obj.price+".00"
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
    
    
    @objc func Edit(_ sender: UIButton){
        //let btnsendtag:Int? = sender.tag
        print(sender.tag)
        selectIndex = sender.tag
        let sheet = UIAlertController(title: "Cart  ", message:nil, preferredStyle: .actionSheet) // Initialize action sheet type
        
        let Bank = UIAlertAction(title: "Edit", style: .default, handler: { action in
            let obj = self.notificaionArray[self.selectIndex]
            StaticData.singleton.menu_item = obj.name
            StaticData.singleton.menu_Description = obj.myDesc
            StaticData.singleton.currSymbol = obj.myCurrency
            StaticData.singleton.menu_price = obj.price
            StaticData.singleton.MenuItemID = obj.id1
            StaticData.singleton.Rest_id = obj.myRestID
            StaticData.singleton.restFee = obj.myFee
            StaticData.singleton.restTax = obj.myTax
            StaticData.singleton.MinOrderprice = obj.Minprice
             StaticData.singleton.CartKey = obj.key1
            StaticData.singleton.isEditCart = "YES"
            if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                
                let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                let tabViewController:AddCartViewController = (storyboard.instantiateViewController(withIdentifier: "AddCartViewController") as? AddCartViewController)!
                self.present(tabViewController, animated: true, completion: nil)
            }else{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabViewController:AddCartViewController = (storyboard.instantiateViewController(withIdentifier: "AddCartViewController") as? AddCartViewController)!
                self.present(tabViewController, animated: true, completion: nil)
                
            }
            
        })
        
        let MRS = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            // Presents picker
            self.deleteIndex = self.selectIndex
            self.DeleteModule1()
            
            
        })
        
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            // Presents picker
            sheet.hidesBottomBarWhenPushed = true
        })
        
     
        
        // Add actions
        sheet.addAction(Bank)
        sheet.addAction(MRS)
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
    
//    @objc func buttonAction(sender: UIButton!) {
//        let btnsendtag:Int? = sender.tag
//        print(sender.tag)
//
//        self.DeleteModule1()
//
//    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == notificaionArray.count){
            //let obj1 = notificaionArray[indexPath.section-1]
            let cell:CardDetail2TableCell = self.tableview.dequeueReusableCell(withIdentifier: "7thCell") as! CardDetail2TableCell
//            if(StaticData.singleton.cart_addresstotal == ""){
//
//            }else{
//               self.subtotal  = Float(StaticData.singleton.cart_addresstotal!)!
//                //let fee:Float! =  Float(self.myFee)
//                self.totalInvoce = self.subtotal+self.taxvalue
//            }
            cell.txt_promo.text = self.localPromo
            if(StaticData.singleton.cart_addressFee == ""){
                print(self.myFee)
               
                if(isPick == "NO"){
                    
                    let fee:Float! =  Float(self.myFee)
                    print(fee)
                    print(totalInvoce)
                    //self.totalInvoce = self.totalInvoce-fee
                    
                    cell.fee.text = currency+"0"+".00"
                    cell.txt_tip.text = currency+"0.00"
                    //
                   
                    let tip:Float! = Float(self.rider_tip)
                   
                    cell.tip_field.text = ""
                   
                    let myVal:Float! = tip+fee
                    print(myVal)
                    self.totalInvoce = totalInvoce-myVal
                    cell.txt_address.text = "Pick Up"
                    StaticData.singleton.AddressID! = "0"
                    
                }else {
                    cell.btn_pick.backgroundColor = UIColor.init(red: 221/255, green:221/255 , blue:221/255 , alpha:1.0 )
                    cell.btn_delivery.backgroundColor = UIColor.init(red:190/255 , green:44/255  , blue:44/255  , alpha: 1.0)
                    cell.btn_pick.setTitleColor(UIColor.black, for: .normal)
                    cell.btn_delivery.setTitleColor(UIColor.white, for: .normal)
                    
                    let fee:Float! =  Float(self.myFee)
                  
                    //self.totalInvoce = self.totalInvoce+fee
                   
                    cell.fee.text = currency+self.myFee+".00"
                    cell.txt_tip.text = currency+self.rider_tip+".00"
                  
                    let tip:Float! = Float(self.rider_tip)
                    if(self.rider_tip == "0"){
                        cell.tip_field.text = ""
                    }else{
                        cell.tip_field.text = self.rider_tip
                        
                    }
                    let myVal:Float! = tip+fee
                    print(myVal)
                    self.totalInvoce = totalInvoce+myVal
                    cell.txt_address.text = ""

                    
                }
                
            }else{
                if(isPick == "NO"){
                    self.myFee = StaticData.singleton.cart_addressFee!
                    let fee:Float! =  Float(self.myFee)
                    //self.totalInvoce = self.totalInvoce-fee
                    cell.fee.text = currency+"0"+".00"
                    cell.txt_tip.text = currency+"0.00"
                    let tip:Float! = Float(self.rider_tip)
                    
                        cell.tip_field.text = ""
                        
                    
                    let myVal:Float! = tip+fee
                    self.totalInvoce = totalInvoce-myVal
                    cell.txt_address.text = "Pick Up"
                    StaticData.singleton.AddressID = "0"
                    
                }else{
                    cell.btn_pick.backgroundColor = UIColor.init(red: 221/255, green:221/255 , blue:221/255 , alpha:1.0 )
                    cell.btn_delivery.backgroundColor = UIColor.init(red:190/255 , green:44/255  , blue:44/255  , alpha: 1.0)
                    cell.btn_pick.setTitleColor(UIColor.black, for: .normal)
                    cell.btn_delivery.setTitleColor(UIColor.white, for: .normal)
                    self.myFee = StaticData.singleton.cart_addressFee!
                    let fee:Float! =  Float(self.myFee)
                    //self.totalInvoce = self.totalInvoce+fee
                    cell.fee.text = currency+self.myFee
                    cell.txt_tip.text = currency+self.rider_tip+".00"
                    
                    let tip:Float! = Float(self.rider_tip)
                    if(self.rider_tip == "0"){
                        cell.tip_field.text = ""
                    }else{
                        cell.tip_field.text = self.rider_tip
                        
                    }
                    let myVal:Float! = tip+fee
                    self.totalInvoce = totalInvoce+myVal
                    cell.txt_address.text = StaticData.singleton.cardAddress
                    
                }
                    
                
              
               
            }
            
//            if(self.isTip == "YES"){
//                let fee:Float! =  Float(self.myFee)
//                self.totalInvoce = totalInvoce-fee
//                
//            }
            
//            if(self.isTip == "NO"){
//
//               cell.txt_tip.text = currency+"0.00"
//                //
//                let tip:Float! = Float(self.rider_tip)
//                self.totalInvoce = totalInvoce-tip
//
//                self.rider_tip = "0.00"
//
//
//            }else if(self.isTip == "YES"){
//
//               cell.txt_tip.text = currency+self.rider_tip
//                let tip:Float! = Float(self.rider_tip)
//                print(tip)
//                print(self.totalInvoce)
//                self.totalInvoce = tip+totalInvoce
//
//            }
           
            
            self.paramSubTotal = String(format: "%.2f",Float(self.subtotal))
            cell.subtotal.text = currency+String(format: "%.2f",Float(self.subtotal))
            paramTotal = String(format: "%.2f",Float(self.totalInvoce))
            cell.total.text = currency+String(format: "%.2f",Float(self.totalInvoce))
            self.paramTax = String(format: "%.2f",Float(self.taxvalue))
            //cell.fee.text = currency+self.myFee+".00"
            cell.tax.text =  currency+String(format: "%.2f",Float(self.taxvalue))
           
           
            let str1:String = self.myTax+"%"
            let str2:String = "("
            let str3:String = ")"
            let str4:String = str2+str1+str3
            cell.tex_label.text = str4
            let a1:Float! = Float(self.Minorderprice)
            let a2:Float! = Float(self.paramSubTotal)
            let a3:Float! = a1-a2
            
            if(a3 >= a1){
                
                self.mainLabel.text = "You have reached your free delivery order."
            }else{
                if(String(format: "%.2f",Float(a3)).contains("-")){
                    
                    self.mainLabel.text = "You have reached your free delivery order."
                }else{
               self.mainLabel.text = "You have to need more "+currency+String(format: "%.2f",Float(a3))+" for free delivery order."
                }
                
            }

            if(StaticData.singleton.cardnumber == nil || StaticData.singleton.cardnumber == ""){

               cell.txt_payment.text = ""
            }else{

            cell.txt_payment.text = StaticData.singleton.cardnumber
        }

//            if(StaticData.singleton.cardAddress == nil || StaticData.singleton.cardAddress == ""){
//
//                //cell.btn_address.setTitle("Select Delivery Address", for:.normal)
//
//            }else{
//
//
//
//
//            }
            
            
            cell.btn_delivery.addTarget(self, action: #selector(DetailCartViewController.pressPlay1(_:)), for: .touchUpInside)
            cell.btn_pick.addTarget(self, action: #selector(DetailCartViewController.pressPlay2(_:)), for: .touchUpInside)
            
            cell.btn_send.addTarget(self, action: #selector(DetailCartViewController.pressPlay(_:)), for: .touchUpInside)
            cell.btn_address.addTarget(self, action: #selector(DetailCartViewController.pressPlay3(_:)), for: .touchUpInside)
            cell.btn_tip.addTarget(self, action: #selector(DetailCartViewController.pressPlay4(_:)), for: .touchUpInside)
            
            cell.btn_payment.addTarget(self, action: #selector(DetailCartViewController.pressPlay5(_:)), for: .touchUpInside)
           
            return cell
        }else{
        
            let cell:CardDetailTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "6thCell") as! CardDetailTableViewCell
           let obj:cartlist = notificaionArray[indexPath.section].listOfcarts[indexPath.row]
            let obj1 = notificaionArray[indexPath.section]
            
            titleName.text = UserDefaults.standard.string(forKey:"rest")!.uppercased()
            //cell.price.text = "$ "+obj.price1
            //let obj1 = ExtramenuItemList[indexPath.row] as! ExtraMenuItem
//            cell.name.text = obj.name1+" x"+obj.description1
//            let range = NSRange(location:(cell.name.text?.characters.count)!-3,length:3) // specific location. This means "range" handle 1 character at location 2
//
//            let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: cell.name.text!, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
//            // here you change the character to red color
//            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: range)
//            cell.name.attributedText = attributedString
//
            let str:String! = obj1.myquantity+"x "+obj.name1
            
            cell.subname.text = str+" +"+obj1.myCurrency+obj.price1+""
         
            
            return cell
        }
        
        
    }
    @objc func pressPlay1(_ sender: UIButton){
        if(isPick == "NO"){
        self.delivery
            = "1"
        //self.rider_tip = "0"
        //self.isTip = "NO"
       // self.tipView.alpha = 0
        let indexPath = IndexPath(row:0, section:notificaionArray.count)
        let cell = tableview.cellForRow(at: indexPath) as! CardDetail2TableCell
        
        cell.btn_address.isUserInteractionEnabled = true
        cell.txt_address.isUserInteractionEnabled = false
        cell.btn_tip.isUserInteractionEnabled = true
        cell.txt_tip.isUserInteractionEnabled = false
        
        cell.btn_pick.backgroundColor = UIColor.init(red: 221/255, green:221/255 , blue:221/255 , alpha:1.0 )
        cell.btn_delivery.backgroundColor = UIColor.init(red:190/255 , green:44/255  , blue:44/255  , alpha: 1.0)
        cell.btn_pick.setTitleColor(UIColor.black, for: .normal)
        cell.btn_delivery.setTitleColor(UIColor.white, for: .normal)
        self.isPick = "YES"
        //self.isTip = "YES"
        
        //self.LoadCartDetail()
        self.tableview.reloadData()
    }

}
    
    @objc func pressPlay2(_ sender: UIButton){
       if(isPick == "YES"){
        self.delivery
            = "0"
        //self.rider_tip = "0"
        //self.isTip = "NO"
        //self.tipView.alpha = 0
        let indexPath = IndexPath(row:0, section:notificaionArray.count)
        let cell = tableview.cellForRow(at: indexPath) as! CardDetail2TableCell
        
        
        cell.btn_address.isUserInteractionEnabled = false
        cell.txt_address.isUserInteractionEnabled = false
        cell.btn_pick.backgroundColor = UIColor.init(red:190/255 , green:44/255  , blue:44/255  , alpha: 1.0)
        cell.btn_delivery.backgroundColor = UIColor.init(red: 221/255, green:221/255 , blue:221/255 , alpha:1.0 )
        cell.btn_pick.setTitleColor(UIColor.white, for: .normal)
        cell.btn_delivery.setTitleColor(UIColor.black, for: .normal)
        cell.btn_tip.isUserInteractionEnabled = false
        cell.txt_tip.isUserInteractionEnabled = false
        self.isTip = "NO"
        self.isPick = "NO"
        //self.LoadCartDetail()
        self.tableview.reloadData()
        }
    }
    @objc func pressPlay3(_ sender: UIButton){
        if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabViewController:SelectAddressPresent = (storyboard.instantiateViewController(withIdentifier: "SelectAddressPresent") as? SelectAddressPresent)!
            tabViewController.sub_total = String(self.subtotal)
            tabViewController.restaurant_id = UserDefaults.standard.string(forKey:"Rest_id")!
            present(tabViewController, animated: true, completion:nil)
        }else{
            StaticData.singleton.isCartLogin = "YES"
            self.performSegue(withIdentifier:"backLogin", sender: self)
        }
       
        
          }
    
    @objc func pressPlay5(_ sender: UIButton){
        if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabViewController:PaymentMethodPresent = (storyboard.instantiateViewController(withIdentifier: "PaymentMethodPresent") as? PaymentMethodPresent)!
          
            present(tabViewController, animated: true, completion:nil)
        }else{
            StaticData.singleton.isCartLogin = "YES"
            self.performSegue(withIdentifier:"backLogin", sender: self)
        }
        
        
    }
        @objc func pressPlay(_ sender: UIButton){
          if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            self.blurview.alpha = 1
            UIView.animate (withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut ,animations: {
                
                self.promo_view.alpha = 1
                //            var basketTopFrame = self.tipView.frame
                //            basketTopFrame.origin.y -= basketTopFrame.size.height-350
                //
                //            var basketBottomFrame = self.tipView.frame
                //            basketBottomFrame.origin.y += basketBottomFrame.size.height
                
                //self.tipView.frame = basketTopFrame
                //self.tipView.frame = basketBottomFrame
            }, completion: {
                (value: Bool) in
                //self.blurBg.hidden = true
                
            })
            }else{
    StaticData.singleton.isCartLogin = "YES"
    self.performSegue(withIdentifier:"backLogin", sender: self)
    }
            
          
            
    }
    
    @objc func pressPlay4(_ sender: UIButton){
        
       
        self.blurview.alpha = 1
      
        UIView.animate (withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut ,animations: {
            
            self.tipView.alpha = 1
            //            var basketTopFrame = self.tipView.frame
            //            basketTopFrame.origin.y -= basketTopFrame.size.height-350
            //
            //            var basketBottomFrame = self.tipView.frame
            //            basketBottomFrame.origin.y += basketBottomFrame.size.height
            
            //self.tipView.frame = basketTopFrame
            //self.tipView.frame = basketBottomFrame
        }, completion: {
            (value: Bool) in
            //self.blurBg.hidden = true
            
        })
        
        
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
    
    
   
    func DeleteModule1(){
       
        
        let alertController = UIAlertController(title:"Warning!", message:"Are you sure you want to delete?", preferredStyle: .alert)
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        let alertAction2 = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction!) in
            let obj = self.notificaionArray[self.deleteIndex]
                    let val = FIRDatabase.database().reference().child("Cart").child(UserDefaults.standard.string(forKey:"udid")!)
                    val.observeSingleEvent(of:.value, with: { snapshot in
            
                        if snapshot.childrenCount > 0 {
                            for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
            
                                let artistObject = artists.value as? [String: AnyObject]
                                if(obj.key1 == artistObject?["key"] as! String){
                                    print(obj.key1)
                                    print(artists.key)
                                   val.child(artists.key).removeValue()
            
                                    self.LoadCartDetail()
                                }else{
            
            
                                }
                            }
                        }
            
                    })
         
            
        })
        
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
      
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func promo_cancel(_ sender: Any) {
        self.blurview.alpha = 0
        self.promo_view.alpha = 0
        
    }
    
    @IBAction func promo_Done(_ sender: Any) {
        
        if(txt_codePromo.text!.isEmpty){
            
            self.alertModule(title:"Error", msg:"Please enter your promo code.")
        }else{
            
                self.blurview.alpha = 0
                self.promo_view.alpha = 0
                promr = txt_codePromo.text!
                self.addCoupanApi()
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
