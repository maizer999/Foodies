//
//  AddPaymentMethodViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/4/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import SwiftyJSON
import KRProgressHUD
import DatePickerDialog
class AddPaymentMethodViewController: UIViewController,UITextFieldDelegate {
    
     @IBOutlet weak var myView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var btn_save: UIBarButtonItem!
    
    @IBOutlet weak var txt_cardNumber: UITextField!
    
    @IBOutlet weak var txt_validity: UITextField!
    
    @IBOutlet weak var txt_cvv: UITextField!
    
    @IBOutlet weak var cardName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt_cardNumber.delegate = self
        txt_cvv.delegate = self
        txt_validity.delegate = self
        
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == txt_validity){
            
            let num:NSString = txt_validity.text! as NSString;
            if num.length == 1
            {
                textField.text = NSString(format:"%@%@/",num,string) as String
                return false;
            }
            if num.length >= 5 {
                //        allows only two more characters "17".
                return false;
            }
            return true;
            
        }else
        
        if textField == txt_cvv{
            let newLength = (txt_cvv.text?.characters.count)! + string.characters.count - range.length
        return newLength <= 4
    }
        else
        if textField == txt_cardNumber
        {
            let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789").inverted) == nil
            
            if !replacementStringIsLegal
            {
                return false
            }
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 16 && !hasLeadingOne) || length > 19
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 16) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if length - index > 4 //magic number separata every four characters
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                formattedString.appendFormat("%@ ", prefix)
                index += 4
            }
            
            if length - index > 4
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                formattedString.appendFormat("%@ ", prefix)
                index += 4
            }
            if length - index > 4
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                formattedString.appendFormat("%@ ", prefix)
                index += 4
            }
            
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
    }
    
    @IBAction func addcardDetail(_ sender: Any) {
        
        if(cardName.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Card Name.")
        }else if(txt_cardNumber.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Card Number.")
        }else if(txt_cvv.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Card CVV.")
        }else if(txt_validity.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Card Validity.")
        }else{
            
           self.CheckCard()
        }
        
    }
    
 
    
    
    func CheckCard(){
        appDelegate.showActivityIndicatory(uiView:myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        var string:String!
        let cardParams = STPCardParams()
        cardParams.number = txt_cardNumber.text
        cardParams.name = cardName.text
        if(txt_validity.text?.contains("/"))!{
            var fullNameArr = txt_validity.text?.components(separatedBy: "/")
            let firstName:Int = Int(fullNameArr![0])!
            let str:Int = Int(fullNameArr![1])!
            
            cardParams.expMonth = UInt(firstName)
            cardParams.expYear = UInt(str)
            
            cardParams.cvc = txt_cvv.text
            STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
                if let error = error {
                    self.myView.isUserInteractionEnabled = true
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                    string = error.localizedDescription
                    self.alertModule(title:"Error", msg:string)
                    // show the error to the user
                } else if token != nil {
                   
                    self.addPaymentApi()
                }
                
            }
                
        }
        
        
    }
    
    @IBAction func expiryDate(_ sender: Any) {
        
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode:.date) {
            (backDate) -> Void in
            if let dt = backDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/yy"
                
                self.txt_validity.text = dateFormatter.string(from:dt)
                
            }
        }
    }
    
    
    func addPaymentApi(){
        let cardParams = STPCardParams()
       // appDelegate.showActivityIndicatory(uiView: self.view)
        
        let url : String = appDelegate.baseUrl+appDelegate.addPaymentMethod
        if(txt_validity.text?.contains("/"))!{
            var fullNameArr = txt_validity.text?.components(separatedBy: "/")
            let firstName:Int = Int(fullNameArr![0])!
            let str:Int = Int(fullNameArr![1])!
            
            cardParams.expMonth = UInt(firstName)
            cardParams.expYear = UInt(str)
        }
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"name":cardName.text!,"card":txt_cardNumber.text!,"cvc":txt_cvv.text!,"exp_month":cardParams.expMonth,"exp_year":cardParams.expYear,"default":"1"]
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
                    
                   
                    //self.alertModule(title:"Success",msg:"Card added successfully")
                    
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
            if title == "Success" {
                
                
            }
        })
        
        alertController.addAction(alertAction)
     
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
         self.dismiss(animated: true, completion: nil)
    }
    

    


}
