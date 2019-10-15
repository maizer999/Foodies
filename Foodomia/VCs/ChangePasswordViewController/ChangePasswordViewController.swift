//
//  ChangePasswordViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/17/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var myView: UIView!
   
    @IBOutlet weak var txt_old: UITextField!
    
    @IBOutlet weak var txt_new: UITextField!
    
    @IBOutlet weak var txt_confirm: UITextField!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RecoverPwd(_ sender: Any) {
     
        
        if(txt_old.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Old Password.")
        }else if(txt_new.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your New Password.")
            
        }else if(txt_confirm.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Confirm Password.")
            
        }else if(txt_confirm.text != txt_new.text){
            
            self.alertModule(title:"Error", msg:"New Password doesn't match with Confirm Password.")
            
        }else if((txt_old.text?.characters.count)!<6){
            
            self.alertModule(title:"Error", msg:"Password requires atleast 6 characters.")
        }else if((txt_new.text?.characters.count)!<6){
            
            self.alertModule(title:"Error", msg:"Password requires atleast 6 characters.")
        }
        else{
            
            self.ChangepwdApi()
        }
        
    }
    
    func ChangepwdApi(){
        
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let url : String = appDelegate.baseUrl+appDelegate.changePassword
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"old_password":txt_old.text!,"new_password":txt_new.text!]
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
                    
                    //self.alertModule(title:"Success",msg:dic["msg"] as! String)
                    self.navigationController?.popViewController(animated: true)
                    
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
