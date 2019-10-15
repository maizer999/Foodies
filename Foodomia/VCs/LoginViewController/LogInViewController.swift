//
//  LogInViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/21/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import KRProgressHUD
import GoogleSignIn
import CoreLocation

class LogInViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet var txt_email: UITextField!
    
    @IBOutlet var txt_password: UITextField!
     var locationManager:CLLocationManager!
    
    var Llat:String! = ""
    var Llon:String! = ""
   
    
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        txt_email.text = UserDefaults.standard.string(forKey:"email")
        txt_password.text = UserDefaults.standard.string(forKey:"pwd")
        StaticData.singleton.Profile_status = "YES"
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Verdana", size:14.0)]
//         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.determineMyCurrentLocation()
    }
    
    @IBAction func Login(_ sender: Any) {
        
        let isValid:Bool = appDelegate.isValidEmail(testStr:txt_email.text!)
        
        if(txt_email.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Email.")
        }else if(txt_password.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Password.")
        }else if(!isValid){
            
            self.alertModule(title:"Error", msg:"Please enter valid Email.")
            
        }else if((txt_password.text?.characters.count)!<6){
            
            self.alertModule(title:"Error", msg:"Password requires atleast 6 characters.")
        }else{
            
            self.SignInApi()
           
            }

    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        Llat = String(userLocation.coordinate.latitude)
        Llon = String(userLocation.coordinate.longitude)
        
        StaticData.singleton.center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        manager.stopUpdatingLocation()
        
        
    }
    
    func SignInApi(){
        
   appDelegate.showActivityIndicatory(uiView:self.view)
        
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
       var parameter :[String:Any]?
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let url : String = appDelegate.baseUrl+appDelegate.loginUser
        if(UserDefaults.standard.string(forKey:"DeviceToken") == nil){
           parameter  = ["email":txt_email.text!,"password":txt_password.text!,"device_token":"123","lat":Llat,"long":Llon]
            
        }else{
            
            parameter  = ["email":txt_email.text!,"password":txt_password.text!,"device_token":UserDefaults.standard.string(forKey:"DeviceToken")!,"lat":Llat,"long":Llon]
        }
        
       
        //UserDefaults.standard.string(forKey:"DeviceToken")!
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                let json  = value
                //activityIndicatorView.stopAnimating()
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    let dic1 = dic["msg"] as! NSDictionary
                    let dic2 = dic1["UserInfo"] as! NSDictionary
                    let dic3 = dic1["User"] as! NSDictionary
                    let dic4 = dic1["Admin"] as! NSDictionary
                   
                    StaticData.singleton.uid = dic2["user_id"] as? String
                    StaticData.singleton.email = self.txt_email.text
                    StaticData.singleton.pwd = self.txt_password.text
                    StaticData.singleton.first_name = dic2["first_name"] as? String
                    StaticData.singleton.last_name = dic2["last_name"] as? String
                    StaticData.singleton.contactNO = dic2["phone"] as? String
                    UserDefaults.standard.set("YES", forKey:"isLogin")
                    UserDefaults.standard.set(self.txt_email.text, forKey:"email")
                    UserDefaults.standard.set(self.txt_password.text, forKey:"pwd")
                    UserDefaults.standard.set(StaticData.singleton.uid, forKey:"uid")
                    UserDefaults.standard.set(StaticData.singleton.first_name, forKey:"first_name")
                    UserDefaults.standard.set(StaticData.singleton.last_name, forKey:"last_name")
                    UserDefaults.standard.set(StaticData.singleton.contactNO, forKey:"contactNO")
                    UserDefaults.standard.set(dic4["user_id"] as? String, forKey:"aid")
                    UserDefaults.standard.set(dic3["role"] as! String, forKey:"UserType")
                    
                    if(dic3["role"] as! String == "user"){
                        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                    let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                    let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!
                        self.present(tabViewController, animated: true, completion: nil)
                        } else{
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID") as? UITabBarController)!
                            self.present(tabViewController, animated: true, completion: nil)
                            
                            }
                    }else if(dic3["role"] as! String == "rider"){
                        
                        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                        
                        let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                        let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID2") as? UITabBarController)!
                        self.present(tabViewController, animated: true, completion: nil)
                        }else{
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID2") as? UITabBarController)!
                            self.present(tabViewController, animated: true, completion: nil)
                            
                        }
                    }else{
                        
                        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
                            
                            let storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                            let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID3") as? UITabBarController)!
                            self.present(tabViewController, animated: true, completion: nil)
                        }else{
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabViewController:UITabBarController = (storyboard.instantiateViewController(withIdentifier: "TheAssignedID3") as? UITabBarController)!
                            self.present(tabViewController, animated: true, completion: nil)
                            
                        }
                    }
                    
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
    
   
    
    @IBAction func LoginFB(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        
                        
                    }
                }
            }
        }
        
    }
    
    func getFBUserData(){
        appDelegate.showActivityIndicatory(uiView: self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let dict = result as! [String : AnyObject]
                    print(dict)
                    if let dict = result as? [String : AnyObject]{
                    if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" ){
                        
                            self.view.isUserInteractionEnabled = true
                            KRProgressHUD.dismiss {
                                print("dismiss() completion handler.")
                        }
                        
                        self.alertModule(title:"Error", msg:"You cannot signup with this facebook account because your facebook is not linked with any email")
                        
                    }else{
                        KRProgressHUD.dismiss {
                            print("dismiss() completion handler.")
                        }
                        self.view.isUserInteractionEnabled = true
                        self.txt_email.text = dict["email"] as? String
                        //self.txt_password.text = dict["id"] as? String
                        //self.Login(self)
                        
                    }
                    }
                    
                }else{
                    self.view.isUserInteractionEnabled = true
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                }
            })
        }
        
    }
    func GoogleApi(user: GIDGoogleUser!){
        if(user.profile.email == nil || user.userID == nil || user.profile.email == "" || user.userID == ""){
          
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                
            }
            self.alertModule(title:"Error", msg:"You cannot signup with this Google account because your Google is not linked with any email.")
        
        }else{
            KRProgressHUD.dismiss {
                print("dismiss() completion handler.")
            }
            self.view.isUserInteractionEnabled = true
            txt_email.text = user.profile.email
            //txt_password.text = user.userID
            
            //self.Login(self)
        }
        
        
    }
    @IBAction func LoginGmail(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
    
        alertController.addAction(alertAction)
        
       present(alertController, animated: true, completion: nil)
        
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //UIActivityIndicatorView.stopAnimating()
    }
    
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.GoogleApi(user: user)
            
            // ...
        } else {
            
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                
            }
            print("\(error.localizedDescription)")
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
        
    }
    

    

}
