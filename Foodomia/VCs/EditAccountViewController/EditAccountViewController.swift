//
//  EditAccountViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/29/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class EditAccountViewController: UIViewController {
    
    @IBOutlet weak var btn_done: UIBarButtonItem!
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var txt_first: UITextField!
    
    @IBOutlet weak var txt_last: UITextField!
    
    @IBOutlet weak var txt_phone: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.txt_first.text = UserDefaults.standard.string(forKey: "first_name")!
        self.txt_last.text = UserDefaults.standard.string(forKey: "last_name")!
        self.email.text = UserDefaults.standard.string(forKey: "email")!
        self.txt_phone.text = self.formattedNumber(number:UserDefaults.standard.string(forKey: "contactNO")!)
        
        if(StaticData.singleton.Profile_status == "NO"){
            self.txt_first.isUserInteractionEnabled = false
            self.txt_last.isUserInteractionEnabled = false
            self.email.isUserInteractionEnabled = false
            self.txt_phone.isUserInteractionEnabled = false
            self.navigationItem.setRightBarButton(nil, animated:true )
        }else{
            
            self.txt_first.isUserInteractionEnabled = true
            self.txt_last.isUserInteractionEnabled = true
            self.email.isUserInteractionEnabled = false
            self.txt_phone.isUserInteractionEnabled = false
            
        }
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    @IBAction func Done(_ sender: Any) {
        
        
        if(txt_first.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your First Name.")
        }else if(txt_last.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Last Name.")
        }else if(txt_phone.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter enter Phone Number.")
            
        }else{
            
            self.UpdateProfileApi()
            
        }
        
    }
    
    func UpdateProfileApi(){
        
        appDelegate.showActivityIndicatory(uiView: self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.editUserProfile
        
        let parameter :[String:Any]? = ["email":email.text,"first_name":txt_first.text,"user_id":UserDefaults.standard.string(forKey: "uid")!,"last_name":txt_last.text]
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    let dic1 = dic["msg"] as! NSDictionary
                    let dic2 = dic1["UserInfo"] as! NSDictionary
                    let dic3 = dic1["User"] as! NSDictionary
                    print(dic2)
                    StaticData.singleton.uid = dic2["user_id"] as? String
                    self.txt_first.text = dic2["first_name"] as? String
                    self.txt_last.text = dic2["last_name"] as? String
                    StaticData.singleton.first_name = dic2["first_name"] as? String
                    StaticData.singleton.last_name = dic2["last_name"] as? String
                    StaticData.singleton.contactNO = dic2["phone"] as? String
                    StaticData.singleton.uid = dic2["user_id"] as? String
                    UserDefaults.standard.set(StaticData.singleton.uid, forKey:"uid")
                    UserDefaults.standard.set(StaticData.singleton.first_name, forKey:"first_name")
                    UserDefaults.standard.set(StaticData.singleton.last_name, forKey:"last_name")
                    UserDefaults.standard.set(StaticData.singleton.contactNO, forKey:"contactNO")
                    self.email.text = dic3["email"] as? String
                    
                    self.txt_phone.text = self.formattedNumber(number:(dic2["phone"] as? String)!)
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    private func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mask = "(XXX) XXX XXXXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask.characters {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
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
