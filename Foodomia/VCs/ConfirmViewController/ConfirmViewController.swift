//
//  ConfirmViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/21/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
class ConfirmViewController: UIViewController,UITextFieldDelegate {
     @IBOutlet weak var myView: UIView!
     let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var View1: UIView!
    
    @IBOutlet var view2: UIView!
    
    @IBOutlet var view3: UIView!
    
    @IBOutlet var view4: UIView!
    
    @IBOutlet var textFieldA: UITextField!
    
    @IBOutlet var textFieldB: UITextField!
    
    @IBOutlet var textFieldC: UITextField!
    
    @IBOutlet var textFieldD: UITextField!
    
    
    @IBOutlet var buttonview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.View1.layer.borderWidth = 2
        self.View1.layer.borderColor = UIColor.init(red:221/255.0, green:221/255.0, blue:221/255.0, alpha: 1.0).cgColor
        self.view2.layer.borderWidth = 2
        self.view2.layer.borderColor = UIColor.init(red:221/255, green:221/255.0, blue:221/255.0, alpha: 1.0).cgColor
        self.view3.layer.borderWidth = 2
        self.view3.layer.borderColor = UIColor.init(red:221/255, green:221/255.0, blue:221/255.0, alpha: 1.0).cgColor
        self.view4.layer.borderWidth = 2
        self.view4.layer.borderColor = UIColor.init(red:221/255.0, green:221/255.0, blue:221/255.0, alpha: 1.0).cgColor
        buttonview.layer.cornerRadius = buttonview.frame.size.height/2
        buttonview.layer.masksToBounds = true
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        textFieldA.delegate = self
        textFieldB.delegate = self
        textFieldC.delegate = self
        textFieldD.delegate = self
        
        print(StaticData.singleton.contactNO!)
  
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if(textField == textFieldA){

            textFieldA.text = ""

        }else if(textField == textFieldB){

            textFieldB.text = ""

        }else if(textField == textFieldC){

            textFieldC.text = ""
        }else{
            textFieldD.text = ""

        }
    }
    
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let newLength: Int = newString.length
        if textField == textFieldA {
            if newLength == 2 {
                textFieldB.becomeFirstResponder()
            }
        }
        if textField == textFieldB{
            if newLength == 2 {
                textFieldC.becomeFirstResponder()
            }
        }
        if textField  == textFieldC {
            if newLength == 2 {
                textFieldD.becomeFirstResponder()
            }
        }
        if textField == textFieldD {
            if newLength == 2 {
                self.view.endEditing(true)
            }
        }
        return true
    }
    
    
    @IBAction func ConfirmCode(_ sender: Any) {
        
        if(textFieldA.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
        }else if(textFieldB.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
        }else if(textFieldC.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
        }
        else if(textFieldD.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Verification Code.")
        }else{
            
            self.VerifyApi()
        }
    }
    
    
    func VerifyApi(){
        
        appDelegate.showActivityIndicatory(uiView: myView)
        
         KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let url : String = appDelegate.baseUrl+appDelegate.verifyPhoneNo
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let parameter :[String:Any]? = ["verify":"1","phone_no":StaticData.singleton.contactNO!,"code":textFieldA.text!+textFieldB.text!+textFieldC.text!+textFieldD.text!]
        
        print(parameter!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabViewController:UITabBarController =  (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!
        self.present(tabViewController, animated: true, completion: nil)
        
        
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
                 
                    self.SignUpApi()
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error", msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    func SignUpApi(){
        
      
        
        let url : String = appDelegate.baseUrl+appDelegate.registerUser
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        var parameter :[String:Any]?
        if(UserDefaults.standard.string(forKey:"DeviceToken") == nil){
            parameter = ["email":StaticData.singleton.email!,"password":StaticData.singleton.Password!,"device_token":"123","first_name": StaticData.singleton.first_name!,"last_name":StaticData.singleton.last_name!,"phone":StaticData.singleton.contactNO!,"role":"user"]
        }else{
            parameter = ["email":StaticData.singleton.email!,"password":StaticData.singleton.Password!,"device_token":UserDefaults.standard.string(forKey:"DeviceToken")!,"first_name": StaticData.singleton.first_name!,"last_name":StaticData.singleton.last_name!,"phone":StaticData.singleton.contactNO!,"role":"user"]
            
        }
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
                   
                   
                    
                                        let dic1 = dic["msg"] as! NSDictionary
                                        let dic2 = dic1["UserInfo"] as! NSDictionary
                                        print(dic2)
                                        StaticData.singleton.uid = dic2["user_id"] as? String
                                        UserDefaults.standard.set("YES", forKey:"isLogin")
                                        UserDefaults.standard.set(StaticData.singleton.email!, forKey:"email")
                                        UserDefaults.standard.set(StaticData.singleton.Password!, forKey:"pwd")
                                        StaticData.singleton.first_name = dic2["first_name"] as? String
                                        StaticData.singleton.last_name = dic2["last_name"] as? String
                                        StaticData.singleton.contactNO = dic2["phone"] as? String
                                        StaticData.singleton.uid = dic2["user_id"] as? String
                                        UserDefaults.standard.set("YES", forKey:"isLogin")
                    
                                        UserDefaults.standard.set(StaticData.singleton.uid, forKey:"uid")
                                        UserDefaults.standard.set("user", forKey:"UserType")
                                        UserDefaults.standard.set(StaticData.singleton.first_name, forKey:"first_name")
                                        UserDefaults.standard.set(StaticData.singleton.last_name, forKey:"last_name")
                                        UserDefaults.standard.set(StaticData.singleton.contactNO, forKey:"contactNO")
                    UserDefaults.standard.set("", forKey:"aid")
                    if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                                        let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                                        let tabViewController:UITabBarController =  (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!
                                           self.present(tabViewController, animated: true, completion: nil)
                    }else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabViewController:UITabBarController =  (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!
                        self.present(tabViewController, animated: true, completion: nil)
                        
                    }
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error", msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    
    @IBAction func ResendCode(_ sender: Any) {
        
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.verifyPhoneNo
        
        let parameter :[String:Any]? = ["verify":"0","phone_no":StaticData.singleton.contactNO!]
        
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                self.self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                   
                   
                     self.alertModule(title:"Success", msg:dic["msg"] as! String)
                    
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error", msg:error.localizedDescription)
                
                
            }
        })
    }
    
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
      
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    



}
