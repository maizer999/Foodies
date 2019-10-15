//
//  RiderProfileViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/20/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON
import PopupDialog
import CoreLocation


class RiderProfileViewController: UIViewController,UIWebViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var main_view: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var innerView: UIView!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        self.title = "Profile"
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestWhenInUseAuthorization()
       

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let view1 = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:20))
        view1.backgroundColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        self.navigationController?.view.addSubview(view1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func profile(_ sender: Any) {
        
        StaticData.singleton.Profile_status = "NO"
        self.performSegue(withIdentifier: "profilestatus", sender: self)
    }
    
    @IBAction func TodayJobs(_ sender: Any) {
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        innerView.isHidden = false
        
        let urlString = "http://www.google.co.in/"
        
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            webView.loadRequest(request)
        }
    }
    
    
    @IBAction func WeeklyEarning(_ sender: Any) {
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.title = "Weekly Earnings"
        
        innerView.isHidden = false
        main_view.isUserInteractionEnabled = false
        let urlString = "http://courier.foodomia.pk/login.php?device=app"
        
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            webView.loadRequest(request)
        }
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        appDelegate.showActivityIndicatory(uiView:innerView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        innerView.isUserInteractionEnabled = true
        KRProgressHUD.dismiss {
            print("dismiss() completion handler.")
        }
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        innerView.isUserInteractionEnabled = true
        KRProgressHUD.dismiss {
            print("dismiss() completion handler.")
        }
    }
    
    @IBAction func AppHelp(_ sender: Any) {
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        self.title = "App Help"
        innerView.isHidden = false
        main_view.isUserInteractionEnabled = false
        let urlString = "https://courier.foodomia.pk/dashboard.php?p=appHelp&device=app"
        
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            webView.loadRequest(request)
        }
        
    }
    
 
    
    @IBAction func close(_ sender: Any) {
        
        self.title = "Profile"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear

        innerView.isHidden = true
        main_view.isUserInteractionEnabled = true
    }
    
  
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func logout(_ sender: Any) {
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        let url : String = appDelegate.baseUrl+appDelegate.showUserOnlineStatus
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"current_datetime":result]
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
                    
                    let myCountry = dic["msg"] as? String
                    
                    
                    if(myCountry! == "1"){
                        UserDefaults.standard.set("0", forKey:"checkin")
                        
                        
                    }else{
                        UserDefaults.standard.set("1", forKey:"checkin")
                       
                        
                    }
                    
                    if(UserDefaults.standard.string(forKey: "checkin") == "1"){
                        UserDefaults.standard.set("NO", forKey:"isLogin")
                        UserDefaults.standard.set("", forKey:"email")
                        UserDefaults.standard.set("", forKey:"pwd")
                        UserDefaults.standard.set("", forKey:"uid")
                        UserDefaults.standard.set("", forKey:"first_name")
                        UserDefaults.standard.set("", forKey:"last_name")
                        UserDefaults.standard.set("", forKey:"contactNO")
                        UserDefaults.standard.set("0", forKey:"checkin")
                        UserDefaults.standard.set("", forKey:"aid")
                        UserDefaults.standard.set("", forKey:"UserType")
                        self.locationManager.allowsBackgroundLocationUpdates = false
                        //UserDefaults.standard.set("", forKey:"location")
                        StaticData.singleton.uid! = ""
                        StaticData.singleton.Rest_id = ""
                        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                            let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                            
                            let tabViewController:UITabBarController =  (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!
                            self.present(tabViewController, animated: true, completion: nil)
                        }else{
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabViewController:UITabBarController =  (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!
                            self.present(tabViewController, animated: true, completion: nil)
                            
                            
                        }
                        
                    }else if(UserDefaults.standard.string(forKey: "checkin") == "0"){
                        
                        
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
                            
                            self.tabBarController?.selectedIndex = 1
                        }
                        let buttonTwo = DefaultButton(title: "Call") {
                            
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
                    
                }else{
                    
                    // self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
                
            case .failure(let error):
                
                print(error)
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                self.alertModule(title:"Error",msg:error.localizedDescription)
               
                }
                
                
            }
        })
        
        
        
    
       
        
    }
    
    
    @IBAction func riderfeed(_ sender: Any) {
        StaticData.singleton.isReviews = "Rider"
        self.performSegue(withIdentifier:"RiderReview", sender:self)
        
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
