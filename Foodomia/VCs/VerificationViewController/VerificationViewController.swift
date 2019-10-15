//
//  VerificationViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/21/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD
import SDWebImage



class VerificationViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var done_btn: UIBarButtonItem!
    @IBOutlet var txt_country: UITextField!
    @IBOutlet var code: UITextField!
    
    var firstname:String? = ""
    var lastname:String? = ""
    var email:String? = ""
    var password:String? = ""
    var PhoneNo:String? = ""
    
    @IBOutlet var txt_contact: UITextField!
    
    @IBOutlet var img_country: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myView.isUserInteractionEnabled = true
        KRProgressHUD.dismiss {
            print("dismiss() completion handler.")
        }
        
        UserDefaults.standard.set("", forKey:"Country")
        UserDefaults.standard.set("", forKey:"CountryCode")
        UserDefaults.standard.set("", forKey:"CountryImage")
        
        
        done_btn.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont.systemFont(ofSize:15, weight: UIFont.Weight.semibold)], for: UIControlState.normal)
        
        txt_contact.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        let font = UIFont(name: "Verdana", size:15)
        done_btn.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font!], for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {

            txt_country.text = UserDefaults.standard.string(forKey:"Country")
            code.text = UserDefaults.standard.string(forKey:"CountryCode")
        img_country.sd_setImage(with: URL(string:UserDefaults.standard.string(forKey:"CountryImage")!), placeholderImage: UIImage(named:"Canada"))
  
    }
    
    
    @IBAction func done(_ sender: Any) {
        
        if(txt_country.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your country.")
        }else if(txt_contact.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your contact number.")
        }else{
            
            
            self.VerifyApi()
            
            //self.performSegue(withIdentifier:"login", sender:nil)
           // self.performSegue(withIdentifier: "signUp", sender:nil)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        PhoneNo = textField.text
        txt_contact.text = self.formattedNumber(number:textField.text!)
        
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
    
    func VerifyApi(){
        
        let phoneNumber = txt_contact.text!
        
        let charsToRemove: Set<Character> = Set(" ()".characters)
        let newNumberCharacters = String(phoneNumber.characters.filter { !charsToRemove.contains($0) })
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
       
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let url : String = appDelegate.baseUrl+appDelegate.verifyPhoneNo
        
        let parameter :[String:Any]? = ["verify":"0","phone_no":code.text!+newNumberCharacters]
        
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
                    StaticData.singleton.contactNO = self.code.text!+newNumberCharacters
                    self.performSegue(withIdentifier:"isVerify", sender:self)
                    
                  
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
        
        present(alertController, animated: true, completion: nil)
        
    }
    
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func seclectCountry(_ sender: Any) {
        
        
    }
    
    @IBAction func Done(_ sender: Any) {
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
