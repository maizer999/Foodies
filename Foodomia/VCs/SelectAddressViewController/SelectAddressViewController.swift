//
//  SelectAddressViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class SelectAddressViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
 @IBOutlet weak var myView: UIView!
    @IBOutlet var tableview: UITableView!
    var AddressList:NSMutableArray = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
       self.getAddressApi()
    }
    
    func getAddressApi(){
        
        AddressList = []
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let url : String = appDelegate.baseUrl+appDelegate.getDeliveryAddresses
        
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
                                            let myAddress = Dict["Address"] as! [String:String]
                                            let apartment = myAddress["apartment"]
                                            let city = myAddress["city"]
                                            let country = myAddress["country"]
                                            let id = myAddress["id"]
                                            let instruction = myAddress["instructions"]
                                            let state = myAddress["state"]
                                            let street = myAddress["street"]
                                            let zip = myAddress["zip"]
                                            let delivery_fee = ""
                                            let total_amount = ""
                                            
                                            let obj = Address(apartment:apartment as! String, city: city as! String, country:country as! String , id:id as! String, instruction:instruction as! String, state:state as! String , street:street as! String , zip:zip as! String,delivery_fee:delivery_fee as! String,total_amount:total_amount as! String)
                    
                                            self.AddressList.add(obj)
                    
                    
                                        }
                                        print(self.AddressList.count)
                                        if(self.AddressList.count == 0){
                                            
                                            self.tableview.reloadData()
                    
//                                            self.alertModule(title:"Error", msg:"NO Address Detail Found.")
                                        }else{
                    
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
                print(error)
                if(error.localizedDescription == "The network connection was lost."){
                    self.getAddressApi()
                }else{
                    self.alertModule(title:"Error",msg:error.localizedDescription)
                }
                
                
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AddressList.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    if(indexPath.row == self.AddressList.count){
        
        let cell:Address1TableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell6") as! Address1TableViewCell
        
        
        return cell
    }else{
    
        let cell:AddressTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell5") as! AddressTableViewCell
        
        let obj = self.AddressList[indexPath.row] as! Address
        let a:String! = obj.street+" ,"+obj.city
        let b:String! = obj.country
        
        cell.myAddress.text = a+" ,"+b
        
        return cell
    
    
    }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == self.AddressList.count){
            
           self.performSegue(withIdentifier:"add", sender:self)
            
           
        }
        
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if(indexPath.row == self.AddressList.count){
//            return false
//        }else{
//            return true
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == UITableViewCellEditingStyle.delete {
//            if(indexPath.row == self.AddressList.count)
//            {
//                //dfdsdsdgsdg
//                
//            }else{
//               
//                
//                let obj = AddressList[indexPath.row] as! Address
//                appDelegate.showActivityIndicatory(uiView: myView)
//                KRProgressHUD.show()

//DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//   KRProgressHUD.dismiss()
//}
//                
//                let url : String = appDelegate.baseUrl+appDelegate.deleteDeliveryAddress
//                
//                let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"id":obj.id]
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
//                            self.getAddressApi()
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
    
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
