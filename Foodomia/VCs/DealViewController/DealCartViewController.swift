//
//  DealCartViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/16/17.
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

class DealCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var hotelname: UILabel!
    
     @IBOutlet weak var blurview: UIView!
    var isPick:String = "YES"
    var delivery:String = "1"
    var isTip:String = "YES"
    
    @IBOutlet weak var mainlabel: UILabel!
   
    var promr:String! = ""
    var coupan_id:String! = ""
    var subtotal:Float = 0.0
    var TotalValue:Float = 0.0
    
    var rider_tip:String = "0.00"
    
    var sub_total:String! = ""
    var tax:String! = ""
    var preivousTip:String! = ""
   
   
    
    @IBOutlet weak var txt_amount: UITextField!
  
    
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var btn_done: UIButton!
    @IBOutlet weak var tip_img: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
   
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        tip_img.layer.masksToBounds = false
        tip_img.layer.cornerRadius = tip_img.frame.height/2
        tip_img.clipsToBounds = true
        
      
        self.tipView.layer.borderWidth = 1
        self.tipView.layer.borderColor =  UIColor.init(red:221/255 , green:221/255  , blue:221/255  , alpha: 1.0).cgColor
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame  = self.view.frame
        blurview.addSubview(blurredEffectView)

        hotelname.text = StaticData.singleton.detailrest!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(StaticData.singleton.cart_addressFee!)
        
        self.tableview.reloadData()
        
    }
    
  
    
    @IBAction func cancel(_ sender: Any) {
        
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
            //self.rider_tip = txt_amount.text!
            print(self.rider_tip)
            isTip = "YES"
            self.blurview.alpha = 0
            self.tipView.alpha = 0
        }
        
        self.tableview.reloadData()
        }else{
            
            self.blurview.alpha = 0
            self.tipView.alpha = 0
        }
    }
    
    
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      
            return 2
    }
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == 1){
            
            return 398
            
        }else{
            
            return 40
        }
        
    }
    

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 1){
            //let obj1 = notificaionArray[indexPath.section-1]
            let cell:CardDetail2TableCell = self.tableview.dequeueReusableCell(withIdentifier: "7thCell") as! CardDetail2TableCell
            
          print(StaticData.singleton.cart_addresstotal!)
            print(StaticData.singleton.cart_addressFee!)
            
            
            
//            if(StaticData.singleton.cart_addresstotal == ""){
//

//
//            }else{
//                let value:Float = Float(StaticData.singleton.detailprice!)!*Float(StaticData.singleton.RestDealQuantity!)!
//                print(value)
//                StaticData.singleton.DealFee = StaticData.singleton.cart_addressFee!
//                self.sub_total = String(format: "%.2f",Float(value))
//                cell.subtotal.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(value))
//
//                let taxvalue:Float = ((value)/100)*Float(StaticData.singleton.DealTax!)!
//                cell.tax.text =  StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(taxvalue))
//                cell.fee.text = StaticData.singleton.dealSymbol!+StaticData.singleton.DealFee!+".00"
//                let totalInvoce:Float = value+Float(StaticData.singleton.DealFee!)!+taxvalue
//                self.tax = String(format: "%.2f",Float(taxvalue))
//                self.TotalValue = totalInvoce
//                cell.total.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(totalInvoce))
//            }
            if(StaticData.singleton.cart_addressFee == ""){
                if(isPick == "NO"){
                                let value:Float = Float(StaticData.singleton.detailprice!)!*Float(StaticData.singleton.RestDealQuantity!)!
                                print(value)
                                self.sub_total = String(format: "%.2f",Float(value))
                                cell.subtotal.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(value))
                
                                let taxvalue:Float = ((value)/100)*Float(StaticData.singleton.DealTax!)!
                                cell.tax.text =  StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(taxvalue))
                                cell.fee.text = StaticData.singleton.dealSymbol!+StaticData.singleton.DealFee!+".00"
                            var totalInvoce:Float = self.TotalValue
                            let fee:Float! = Float(StaticData.singleton.DealFee!)
                    
                            let tip:Float! = Float(self.rider_tip)
                            let myVal:Float! = tip+fee
                            print(myVal)
                            print(totalInvoce)
                            totalInvoce = totalInvoce-myVal
                                self.tax = String(format: "%.2f",Float(taxvalue))
                                self.TotalValue = totalInvoce
                                cell.total.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(totalInvoce))
                    cell.fee.text = StaticData.singleton.dealSymbol!+"0"+".00"
                    cell.txt_tip.text = StaticData.singleton.dealSymbol!+"0.00"

                    cell.txt_address.text = "Pick Up"
                    StaticData.singleton.AddressID = "0"
                }else {
                    cell.btn_pick.backgroundColor = UIColor.init(red: 221/255, green:221/255 , blue:221/255 , alpha:1.0 )
                    cell.btn_delivery.backgroundColor = UIColor.init(red:190/255 , green:44/255  , blue:44/255  , alpha: 1.0)
                    cell.btn_pick.setTitleColor(UIColor.black, for: .normal)
                    cell.btn_delivery.setTitleColor(UIColor.white, for: .normal)
                    let value:Float = Float(StaticData.singleton.detailprice!)!*Float(StaticData.singleton.RestDealQuantity!)!
                    print(value)
                    self.sub_total = String(format: "%.2f",Float(value))
                    cell.subtotal.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(value))
                    
                    let taxvalue:Float = ((value)/100)*Float(StaticData.singleton.DealTax!)!
                    cell.tax.text =  StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(taxvalue))
                    cell.fee.text = StaticData.singleton.dealSymbol!+StaticData.singleton.DealFee!+".00"
                    var totalInvoce:Float = value+Float(StaticData.singleton.DealFee!)!+taxvalue
                    let fee:Float! = Float(StaticData.singleton.DealFee!)
                    
                    let tip:Float! = Float(self.rider_tip)
                    let myVal:Float! = tip+fee
                    totalInvoce = totalInvoce+myVal
                    self.tax = String(format: "%.2f",Float(taxvalue))
                    self.TotalValue = totalInvoce
                    cell.total.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(totalInvoce))
                    cell.txt_address.text = ""
                    cell.txt_tip.text = StaticData.singleton.dealSymbol!+self.rider_tip
                    
                }
            }else{
                if(isPick == "NO"){
                    let value:Float = Float(StaticData.singleton.detailprice!)!*Float(StaticData.singleton.RestDealQuantity!)!
                    print(value)
                    StaticData.singleton.DealFee = StaticData.singleton.cart_addressFee!
                    self.sub_total = String(format: "%.2f",Float(value))
                    cell.subtotal.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(value))
                    
                    let taxvalue:Float = ((value)/100)*Float(StaticData.singleton.DealTax!)!
                    cell.tax.text =  StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(taxvalue))
                    cell.fee.text = StaticData.singleton.dealSymbol!+StaticData.singleton.cart_addressFee!+".00"
                    var totalInvoce:Float = self.TotalValue
                    let fee:Float! = Float(StaticData.singleton.DealFee!)
                    
                    let tip:Float! = Float(self.rider_tip)
                    let myVal:Float! = tip+fee
                    totalInvoce = totalInvoce-myVal
                    self.tax = String(format: "%.2f",Float(taxvalue))
                    self.TotalValue = totalInvoce
                    cell.total.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(totalInvoce))
                    cell.fee.text = StaticData.singleton.dealSymbol!+"0"+".00"
                    cell.txt_tip.text = StaticData.singleton.dealSymbol!+"0.00"
                    cell.txt_address.text = "Pick Up"
                    StaticData.singleton.AddressID = "0"
                }else{
                    cell.btn_pick.backgroundColor = UIColor.init(red: 221/255, green:221/255 , blue:221/255 , alpha:1.0 )
                    cell.btn_delivery.backgroundColor = UIColor.init(red:190/255 , green:44/255  , blue:44/255  , alpha: 1.0)
                    cell.btn_pick.setTitleColor(UIColor.black, for: .normal)
                    cell.btn_delivery.setTitleColor(UIColor.white, for: .normal)
                    let value:Float = Float(StaticData.singleton.detailprice!)!*Float(StaticData.singleton.RestDealQuantity!)!
                    print(value)
                    StaticData.singleton.DealFee = StaticData.singleton.cart_addressFee!
                    self.sub_total = String(format: "%.2f",Float(value))
                    cell.subtotal.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(value))
                    
                    let taxvalue:Float = ((value)/100)*Float(StaticData.singleton.DealTax!)!
                    cell.tax.text =  StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(taxvalue))
                    cell.fee.text = StaticData.singleton.dealSymbol!+StaticData.singleton.cart_addressFee!+".00"
                    var totalInvoce:Float = value+Float(StaticData.singleton.DealFee!)!+taxvalue
                    let fee:Float! = Float(StaticData.singleton.DealFee!)
                    
                    let tip:Float! = Float(self.rider_tip)
                    let myVal:Float! = tip+fee
                    totalInvoce = totalInvoce+myVal
                    self.tax = String(format: "%.2f",Float(taxvalue))
                    self.TotalValue = totalInvoce
                    cell.total.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(totalInvoce))
                    cell.txt_address.text = StaticData.singleton.cardAddress!
                    cell.txt_tip.text = StaticData.singleton.dealSymbol!+self.rider_tip
                }
               
            }
            
            if(self.isTip == "YES"){
                let fee:Float! =  Float(StaticData.singleton.DealFee!)
                print(fee)
                self.TotalValue = self.TotalValue-fee
                
                cell.total.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(self.TotalValue))
                
            }
            
//            if(self.isTip == "NO"){
//
//                cell.txt_tip.text = "--"
//
//                let tip:Float! = Float(self.rider_tip)
//                print(tip)
//                print(self.TotalValue)
//                self.TotalValue = self.TotalValue-tip
//                print(self.TotalValue)
//                cell.total.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(self.TotalValue))
//                self.rider_tip = "0"
//                // self.totalInvoce = self.subtotal+self.taxvalue
//
//            }else if(self.isTip == "YES"){
//
//                cell.txt_tip.text = StaticData.singleton.dealSymbol!+self.rider_tip
//                let tip:Float! = Float(self.rider_tip)
//                self.TotalValue = tip+self.TotalValue
//                cell.total.text = StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(self.TotalValue))
//                //self.totalInvoce = self.subtotal+self.taxvalue
//            }
            print(self.TotalValue)
            print(self.sub_total)
           // self.TotalValue = self.TotalValue
            let a1:Float! = Float(StaticData.singleton.DealMinOrderprice!)
            let a2:Float! = Float(self.sub_total)
            print(self.sub_total)
            print(StaticData.singleton.DealMinOrderprice!)
            let a3:Float! = a1-a2
            
            if(a3 >= a1){
                
                self.mainlabel.text = "You have reached your free delivery order."
            }else{
                if(String(format: "%.2f",Float(a3)).contains("-")){
                    
                    self.mainlabel.text = "You have reached your free delivery order."
                }else{
                    self.mainlabel.text = "You have to need more "+StaticData.singleton.dealSymbol!+String(format: "%.2f",Float(a3))+" for free delivery order."
                }
                
            }
            
            let str1:String = StaticData.singleton.DealTax!+"%"
            let str2:String = "("
            let str3:String = ")"
            let str4:String = str2+str1+str3
            cell.tex_label.text = str4
            if(StaticData.singleton.cardnumber == nil || StaticData.singleton.cardnumber == ""){
                cell.txt_payment.text = ""
            }else{
                
                cell.txt_payment.text = StaticData.singleton.cardnumber
            }
            
//            if(StaticData.singleton.cardAddress == nil || StaticData.singleton.cardAddress == ""){
//
//                //cell.btn_address.setTitle("Select Delivery Address", for:.normal)
//            }else{
//
//                cell.txt_address.text = StaticData.singleton.cardAddress
//
//
//            }
            
           // cell.btn_send.addTarget(self, action: #selector(DealCartViewController.pressPlay(_:)), for: .touchUpInside)
            cell.btn_delivery.addTarget(self, action: #selector(DealCartViewController.pressPlay1(_:)), for: .touchUpInside)
            cell.btn_pick.addTarget(self, action: #selector(DealCartViewController.pressPlay2(_:)), for: .touchUpInside)
            cell.btn_tip.addTarget(self, action: #selector(DealCartViewController.pressPlay4(_:)), for: .touchUpInside)
            cell.btn_address.addTarget(self, action: #selector(DealCartViewController.pressPlay3(_:)), for: .touchUpInside)
            cell.btn_payment.addTarget(self, action: #selector(DealCartViewController.pressPlay5(_:)), for: .touchUpInside)
            return cell
        }else{
            
            let cell:CardDetailTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "6thCell") as! CardDetailTableViewCell
            
            cell.cartPrice.text = StaticData.singleton.dealSymbol!+StaticData.singleton.detailprice!
            cell.subname.text = StaticData.singleton.detailTitle!+" (x"+StaticData.singleton.RestDealQuantity!+")"
  
            return cell
        }
        
        
    }
    
    @objc func pressPlay(_ sender: UIButton){
        let indexPath = IndexPath(row:1, section:0)
        let cell = tableview.cellForRow(at: indexPath) as! CardDetail2TableCell
        if(cell.txt_promo.text!.isEmpty){
            
            self.alertModule(title:"Error", msg:"Please enter your promo code.")
        }else{
            if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
                promr = cell.txt_promo.text!
                self.addCoupanApi()
            }else{
                
                self.performSegue(withIdentifier:"backtodeal", sender: self)
            }
            
        }
        
        
        
        
    }
    
    @objc func pressPlay1(_ sender: UIButton){
        if(isPick == "NO"){
        self.delivery
            = "1"
       
        
        
        let indexPath = IndexPath(row:1, section:0)
        let cell = tableview.cellForRow(at: indexPath) as! CardDetail2TableCell
       
        cell.btn_address.isUserInteractionEnabled = true
        cell.txt_address.isUserInteractionEnabled = false
        cell.btn_delivery.backgroundColor = UIColor.init(red:190/255 , green:44/255  , blue:44/255  , alpha: 1.0)
        cell.btn_pick.backgroundColor = UIColor.init(red: 221/255, green:221/255 , blue:221/255 , alpha:1.0 )
        cell.btn_delivery.setTitleColor(UIColor.white, for: .normal)
        cell.btn_pick.setTitleColor(UIColor.black, for: .normal)
            cell.btn_tip.isUserInteractionEnabled = true
            cell.txt_tip.isUserInteractionEnabled = false
            self.isPick = "YES"
            self.isTip = "YES"
            
            //self.LoadCartDetail()
            self.tableview.reloadData()
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
    
    @objc func pressPlay2(_ sender: UIButton){
        if(isPick == "YES"){
        self.delivery
            = "0"
      
        self.tipView.alpha = 0
        let indexPath = IndexPath(row:1, section:0)
        
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
            tabViewController.restaurant_id = StaticData.singleton.detailrestID!
            present(tabViewController, animated: true, completion:nil)
        }else{
            StaticData.singleton.isDealLogin = "YES"
            self.performSegue(withIdentifier:"backtodeal", sender: self)
        }
        
    }
    
    @objc func pressPlay5(_ sender: UIButton){
        if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            
            let LoginVC:PaymentMethodPresent =  (storyboard!.instantiateViewController(withIdentifier: "PaymentMethodPresent") as? PaymentMethodPresent)!
            self.present(LoginVC, animated: true, completion: nil)
        }else{
            StaticData.singleton.isDealLogin = "YES"
            self.performSegue(withIdentifier:"backtodeal", sender: self)
        }
        
    }
   
    
    
    func CheckoutApi(){
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]

        let url : String = appDelegate.baseUrl+appDelegate.orderDeal
        // < [!] Expected declaration
        var parameter :[String:Any]? = ["":""]
        let value:Float = Float(StaticData.singleton.detailprice!)!*Float(StaticData.singleton.RestDealQuantity!)!
        self.sub_total = String(format: "%.2f",Float(value))
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        let a1:Float! = Float(self.rider_tip)
        let a3:Float! = TotalValue+a1
        if(self.delivery == "0"){
            
            StaticData.singleton.DealFee = "0.00"
            self.rider_tip = "0.00"
        }
        var ver:String! = ""
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            ver = version
        }
        if(StaticData.singleton.AccountID == "cod"){
            parameter  = ["deal_id":StaticData.singleton.dealId!,"user_id":UserDefaults.standard.string(forKey: "uid")!,"name":StaticData.singleton.detailTitle!,"price":String(self.TotalValue),"payment_id":"0","address_id":StaticData.singleton.AddressID!,"restaurant_id":StaticData.singleton.detailrestID!,"cod":"1","order_time":result,"description":StaticData.singleton.detaildes!,"delivery_fee":StaticData.singleton.DealFee!,"sub_total":self.sub_total,"tax":self.tax,"quantity":StaticData.singleton.RestDealQuantity!,"delivery":self.delivery,"rider_tip":self.rider_tip,"device":"iOS","version":ver!]
        }else{
            
                parameter  = ["deal_id":StaticData.singleton.dealId!,"user_id":UserDefaults.standard.string(forKey: "uid")!,"name":StaticData.singleton.detailTitle!,"price":String(self.TotalValue),"payment_id":StaticData.singleton.AccountID!,"address_id":StaticData.singleton.AddressID!,"restaurant_id":StaticData.singleton.detailrestID!,"cod":"0","order_time":result,"description":StaticData.singleton.detaildes!,"delivery_fee":StaticData.singleton.DealFee!,"sub_total":self.sub_total,"tax":self.tax,"quantity":StaticData.singleton.RestDealQuantity!,"delivery":self.delivery,"rider_tip":self.rider_tip,"device":"iOS","version":ver!]
        }
        
        //}
        
        
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
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    StaticData.singleton.RestDealQuantity = "1"
                    StaticData.singleton.AccountID = ""
                    StaticData.singleton.AddressID = ""
                    StaticData.singleton.cardnumber = ""
                    StaticData.singleton.cardAddress = ""
                    StaticData.singleton.cart_addressFee = ""
//                    StaticData.singleton.cart_addresstotal = "";   self.navigationController?.popToRootViewController(animated:true)
               self.tabBarController?.selectedIndex = 2
                    
                    
                    
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
    
    
   
    
    @IBAction func checkout(_ sender: Any) {
        
        let indexPath = IndexPath(row:1, section:0)
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
            
            self.performSegue(withIdentifier:"backtodeal", sender: self)
        }
    }
    
    @IBAction func addaddress(_ sender: Any) {
        
        if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            
            let LoginVC:SelectAddressPresent =  (storyboard!.instantiateViewController(withIdentifier: "SelectAddressPresent") as? SelectAddressPresent)!
            self.present(LoginVC, animated: true, completion: nil)
        }else{
            
            self.performSegue(withIdentifier:"backtodeal", sender: self)
        }
        
        
    }
    
    
    func addCoupanApi(){
        
        // appDelegate.showActivityIndicatory(uiView: self.view)
        
        let url : String = appDelegate.baseUrl+appDelegate.verifyCoupon
        
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"coupon_code":promr,"restaurant_id":StaticData.singleton.detailrestID!]
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
            
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
                        
                        let indexPath = IndexPath(row:1, section:0)
                        let cell = self.tableview.cellForRow(at: indexPath) as! CardDetail2TableCell
                        let myAddress = Dict["RestaurantCoupon"] as! [String:String]
                        let discount = myAddress["discount"] as! String
                        self.coupan_id = myAddress["id"] as! String
                    
                        
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
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
