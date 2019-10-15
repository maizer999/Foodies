//
//  CheckInViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/7/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON
import CoreLocation
import PopupDialog

class CheckInViewController: UIViewController {
    
    @IBOutlet weak var innerView: UIView!
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var checkStatus: UISwitch!
    
    @IBOutlet weak var status_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        innerView.layer.cornerRadius = 21.0
        innerView.layer.borderWidth = 2.0
        innerView.layer.borderColor = UIColor.init(red:221/255, green:221/255.0, blue:221/255.0, alpha: 1.0).cgColor
        if(StaticData.singleton.statusChecking! == "Check Out"){
            
            status_label.text = "Check Out"
            checkStatus.setOn(false, animated:false)
        }else{
            checkStatus.setOn(true, animated:false)
            status_label.text = "Check In"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func checkToggle(_ sender: Any) {
        
        
        
        if(UserDefaults.standard.string(forKey: "checkin") == "1"){
            
            // Prepare the popup assets
            let title = "\(UserDefaults.standard.string(forKey: "first_name")!) \(UserDefaults.standard.string(forKey: "last_name")!)"
            let message = "Are you sure to Check In?"
            
            let popup = PopupDialog(title: title,
                                    message: message,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .zoomIn,
                                    gestureDismissal: true,
                                    hideStatusBar: true) {
                                        print("Completed")
            }
            
            let buttonOne = CancelButton(title: "Cancel") {
                print("You canceled the car dialog.")
                self.status_label.text = "Check Out"
                (sender as AnyObject).setOn(false, animated:false)
            }
            let buttonTwo = DefaultButton(title: "OK") {
                
                self.UpdateRiderStatus()
            }
            
            popup.addButtons([buttonTwo,buttonOne])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }else if(UserDefaults.standard.string(forKey: "checkin") == "0"){
            
            let title = "\(UserDefaults.standard.string(forKey: "first_name")!) \(UserDefaults.standard.string(forKey: "last_name")!)"
            let message = "You have to call or chat with us to check out."
            
            let popup = PopupDialog(title:"Alert!",
                                    message: message,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .zoomIn,
                                    gestureDismissal: true,
                                    hideStatusBar: true) {
                                        print("Completed")
            }
            
            let buttonOne = CancelButton(title: "Chat") {
                StaticData.singleton.isChat = "yes"
                print("You canceled the car dialog.")
                self.status_label.text = "Check In"
                (sender as AnyObject).setOn(true, animated:false)
                self.dismiss(animated:true, completion:nil)
            }
            let buttonTwo = DefaultButton(title: "Call") {
                self.status_label.text = "Check In"
                (sender as AnyObject).setOn(true, animated:false)
                print("You canceled the car dialog.")
                if let phoneCallURL = URL(string: "tel://+923102292129") {
                    
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(phoneCallURL)) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }
                }
                
            }
            
            popup.addButtons([buttonTwo,buttonOne])
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
            
        }
        
    }
    
    func UpdateRiderStatus(){
        
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let url : String = appDelegate.baseUrl+appDelegate.checkIn
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"online":UserDefaults.standard.string(forKey: "checkin")!]
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
                    
                    let myCountry = dic["msg"] as? NSDictionary
                    
                    let myRestaurant = myCountry!["UserInfo"] as! [String:String]
                    
                    if(myRestaurant["online"] == "1"){
                        UserDefaults.standard.set("0", forKey:"checkin")
                        self.status_label.text = "Check In"
                        self.checkStatus.setOn(true, animated:false)
                        
                        
                    }else{
                        UserDefaults.standard.set("1", forKey:"checkin")
                        self.status_label.text = "Check Out"
                        self.checkStatus.setOn(false, animated:false)
                        
                    }
                    
                    
                    self.dismiss(animated:true, completion:nil)
                    
                    
                    
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
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated:true, completion: nil)
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
