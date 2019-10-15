//
//  AddReasonViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 1/8/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD
import Cosmos
import Firebase
import FirebaseDatabase


class AddReasonViewController: UIViewController,UITextViewDelegate  {
    
    @IBOutlet weak var editview: UIView!
    
    @IBOutlet weak var btn_save: UIBarButtonItem!
    @IBOutlet weak var txt_reason: UITextView!
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var childRef0 = FIRDatabase.database().reference().child("restaurant").child(UserDefaults.standard.string(forKey: "uid")!).child("CurrentOrders")
    var childRef1 = FIRDatabase.database().reference().child("restaurant").child(UserDefaults.standard.string(forKey: "uid")!).child("PendingOrders")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(StaticData.singleton.isReason == "Accept"){
        self.title = "Add Instructions"
        txt_reason.delegate = self
        txt_reason.text = "Type Here."
        txt_reason.textColor = UIColor.lightGray
        self.editview.layer.borderWidth = 1
        self.editview.layer.borderColor = UIColor.init(red:235/255.0, green:235/255.0, blue:235/255.0, alpha: 1.0).cgColor
        }else{
            self.title = "Add Decline Reason"
            txt_reason.delegate = self
            txt_reason.text = "Type Here."
            txt_reason.textColor = UIColor.lightGray
            self.editview.layer.borderWidth = 1
            self.editview.layer.borderColor = UIColor.init(red:235/255.0, green:235/255.0, blue:235/255.0, alpha: 1.0).cgColor
            
        }
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        let font = UIFont(name: "Verdana", size:15)
        btn_save.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!], for: .normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type Here."
            textView.textColor = UIColor.lightGray
        }
    }
  
    
    @IBAction func save(_ sender: Any) {
        if(StaticData.singleton.isReason == "Accept"){
            if(txt_reason.text == "Type Here." || txt_reason.text == nil){
                txt_reason.text = ""
                self.UpdateOrderStatus()
            }else{
                
                self.UpdateOrderStatus()
            }
        }else{
        if(txt_reason.text == "Type Here." || txt_reason.text == nil || txt_reason.text == ""){
            
            self.alertModule(title:"Error", msg:"Please enter your Reason.")
        }else{
            
            self.UpdateOrderStatus()
        }
        }
    }
    
    func UpdateOrderStatus(){
        
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
       let parameter :[String:Any]?
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let url : String = appDelegate.baseUrl+appDelegate.updateRestaurantOrderStatus
        if(StaticData.singleton.isReason == "Accept"){
            parameter  = ["order_id":StaticData.singleton.OrderId!,"status":"1","rejected_reason":"","time":result,"accepted_reason":txt_reason.text,"key":StaticData.singleton.hotel_key]
    }else{
         parameter  = ["order_id":StaticData.singleton.OrderId!,"status":"2","rejected_reason":txt_reason.text,"time":result,"accepted_reason":"","key":StaticData.singleton.hotel_key]
    
    }
        
        //print(url)
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
                    StaticData.singleton.isRESReload = "yes"
                    if(StaticData.singleton.isReason == "Accept"){
                    self.childRef0.observeSingleEvent(of:.value, with: { (snapshot) in
                        
                        if snapshot.childrenCount > 0 {
                            for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                                let artistObject = artists.value as? [String: AnyObject]
                                let key = artists.key
                                
                                let order_id = artistObject?["order_id"] as! String
                                let order_status = artistObject?["status"] as! String
                                let order_deal = artistObject?["deal"] as! String
                                let type = artistObject?["type"] as! String
                                if(StaticData.singleton.hotel_key == key){
                                    let message = ["order_id":order_id ,"status":order_status,"deal":order_deal,"type":type] as [String : Any]
                                    self.childRef1.child(key).setValue(message)
                                    self.childRef0.child(key).removeValue()
                                }
                            }
                        }
                    })
                   
                    }else{
                        
                        self.childRef0.observeSingleEvent(of:.value, with: { (snapshot) in
                            
                            if snapshot.childrenCount > 0 {
                                for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                                    let artistObject = artists.value as? [String: AnyObject]
                                    let key = artists.key
//                                    
//                                    let order_id = artistObject?["order_id"] as! String
//                                    
//                                    let order_deal = artistObject?["deal"] as! String
                                    if(StaticData.singleton.hotel_key == key){
                                        
                                        self.childRef0.child(key).removeValue()
                                    }
                                }
                            }
                        })
                    }
                     self.navigationController?.popToRootViewController(animated:true)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
