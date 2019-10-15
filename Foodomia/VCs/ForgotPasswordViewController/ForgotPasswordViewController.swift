//
//  ForgotPasswordViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet var txt_email: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RecoverPwd(_ sender: Any) {
        
        let isValid:Bool = appDelegate.isValidEmail(testStr:txt_email.text!)
        
        if(txt_email.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Email.")
        }else if(!isValid){
            
            self.alertModule(title:"Error", msg:"Please enter valid Email.")
            
        }else{
          
                self.ForgotpwdApi()
            }
            
}
    
    func ForgotpwdApi(){
        
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let url : String = appDelegate.baseUrl+appDelegate.forgotPassword
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["email":txt_email.text!]
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
                //activityIndicatorView.stopAnimating()
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                 // self.alertModule(title:"Success",msg:dic["msg"] as! String)
                  self.dismiss(animated: true, completion:nil)
                    
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
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
      
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        
       self.dismiss(animated: true, completion: nil)
    }


}
