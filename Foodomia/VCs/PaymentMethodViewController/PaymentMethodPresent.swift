//
//  PaymentMethodPresent.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/18/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class PaymentMethodPresent: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var myView: UIView!
    @IBOutlet var tableview: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var myLabel: UILabel!
    var cardArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getPaymentApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Done(_ sender: Any) {
    }
    
    @IBAction func cashonhand(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardArray.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == self.cardArray.count){
            
            return 117
        }else{
            
            return 45
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == self.cardArray.count){
            
            let cell:_rdTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "3rdCell") as! _rdTableViewCell
            
        cell.cash_payment.addTarget(self, action: #selector(PaymentMethodPresent.connect), for: .touchUpInside)
            cell.cash_payment.tag = indexPath.row
            return cell
        }else{
            
            let cell:PaymentTableCell = self.tableview.dequeueReusableCell(withIdentifier: "cell4") as! PaymentTableCell
            
            let obj = cardArray[indexPath.row] as! CardDetail
            cell.card_img.image = UIImage(named: obj.brand)!
            cell.card_number.text = "**** **** **** " + obj.last4
            
            
            return cell
        }
        
        
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        
//        if(indexPath.row == self.cardArray.count){
//            return false
//        }else{
//            return true
//        }
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//         if editingStyle == UITableViewCellEditingStyle.delete {
//        if(indexPath.row == self.cardArray.count)
//        {
//            //dfdsdsdgsdg
//
//        }else{
//            //let index = IndexPath(row: indexPath.row, section:0)
//
//               // self.cardArray.remove(indexPath.row)
//                //tableView.deleteRows(at: [index], with: UITableViewRowAnimation.automatic)
//
//            let obj = cardArray[indexPath.row] as! CardDetail
//                appDelegate.showActivityIndicatory(uiView: myView)
//                KRProgressHUD.show()

//DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//   KRProgressHUD.dismiss()
//}
//
//                let url : String = appDelegate.baseUrl+appDelegate.deletePaymentMethod
//
//                let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"id":obj.cardID]
//                print(url)
//                print(parameter!)
//
//                Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:nil).validate().responseJSON(completionHandler: {
//
//                    respones in
//
//                    switch respones.result {
//                    case .success( let value):
//
//                        let json  = value
//                        self.myView.isUserInteractionEnabled = true
//                        KRProgressHUD.dismiss {
//                            print("dismiss() completion handler.")
//                        }
//                        print(json)
//                        let dic = json as! NSDictionary
//                        let code = dic["code"] as! NSNumber
//                        if(String(describing: code) == "200"){
//
//                            self.getPaymentApi()
//
//
//                        }else{
//
//
//                        }
//
//
//
//                    case .failure(let error):
//                        self.myView.isUserInteractionEnabled = true
//                        KRProgressHUD.dismiss {
//                            print("dismiss() completion handler.")
//                        }
//                        print(error)
//                        self.alertModule(title:"Error",msg:error.localizedDescription)
//
//
//                    }
//                })
//            }
//        }
//    }
    
    @objc func connect(sender: UIButton){
        //let buttonTag = sender.tag
        StaticData.singleton.cardnumber = "Cash On Delivery"
        StaticData.singleton.AccountID = "cod"
        self.dismiss(animated:true, completion:nil)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == self.cardArray.count){
            
            
            
            
        }else{
            
            let obj = cardArray[indexPath.row] as! CardDetail
            StaticData.singleton.cardnumber = "**** **** **** " +
                obj.last4
            StaticData.singleton.AccountID = obj.cardID
            
            DispatchQueue.main.async {
                self.dismiss(animated:true, completion:nil)
            }
        }
    
        
    }
    
    
    
    func getPaymentApi(){
        
        cardArray = []
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let url : String = appDelegate.baseUrl+appDelegate.getPaymentDetails
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!]
        print(url)
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
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        let payment = Dict["PaymentMethod"] as! NSDictionary
                        
                        let brand = Dict["brand"]
                        let last4 = Dict["last4"]
                        let name = Dict["name"]
                        let cardID = payment["id"]
                        
                        let obj = CardDetail(brand:brand as! String ,last4:last4 as! String,name:name as! String,cardID: cardID as! String)
                        
                        self.cardArray.add(obj)
                        
                        
                    }
                    
                    if(self.cardArray.count == 0){
                        
                        self.title = ""
                        self.tableview.reloadData()
                        self.myLabel.isHidden = true
                    }else{
                        self.title = "Select Payment Method"
                        self.tableview.reloadData()
                        self.myLabel.isHidden  = false
                    }
                    
                }else{
                    
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                if(error.localizedDescription == "The network connection was lost."){
                    self.getPaymentApi()
                }else{
                    self.alertModule(title:"Error",msg:error.localizedDescription)
                }
                
                
                
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

}
