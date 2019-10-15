//
//  SignUpViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/21/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import KRProgressHUD
import GoogleSignIn

class SignUpViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {

    @IBOutlet var txt_email: UITextField!
    
    @IBOutlet var txt_first: UITextField!
    
    @IBOutlet var txt_last: UITextField!
    
    @IBOutlet var txt_password: UITextField!
    @IBOutlet weak var myView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUp(_ sender: Any) {
        
        let isValid:Bool = appDelegate.isValidEmail(testStr:txt_email.text!)
        
        if(txt_first.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your First Name.")
        }else if(txt_last.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Last Name.")
        }else if(txt_email.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Email.")
        }else if(txt_password.text?.isEmpty)!{
            
            self.alertModule(title:"Error", msg:"Please enter your Password.")
        }else if((txt_password.text?.characters.count)!<6){
            
             self.alertModule(title:"Error", msg:"Password requires atleast 6 characters.")
        }
        
        else if(!isValid){
            
            self.alertModule(title:"Error", msg:"Please enter valid Email.")
            
        }else{
            
            //self.performSegue(withIdentifier:"login", sender:nil)
            self.performSegue(withIdentifier: "signUp", sender:nil)
            }
            
        
        
        
    }
    
   
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as! VerificationViewController
        
       StaticData.singleton.first_name = txt_first.text
        StaticData.singleton.last_name = txt_last.text
        StaticData.singleton.email = txt_email.text
        StaticData.singleton.Password = txt_password.text
        
      
        
    }
    

    
   
    
    
    @IBAction func LoginFB(_ sender: AnyObject?) {
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
                        if(dict["email"] as? String == nil || dict["id"] as? String == nil || dict["email"] as? String == "" || dict["id"] as? String == "" || dict["first_name"] as? String == nil || dict["last_name"] as? String == nil || dict["first_name"] as? String == nil || dict["last_name"] as? String == nil){
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
                            self.txt_first.text = dict["first_name"] as? String
                            self.txt_last.text = dict["last_name"] as? String
                            self.txt_email.text = dict["email"] as? String
                           // self.txt_password.text = dict["id"] as? String
                            //self.signUp(self)
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
        if(user.profile.email == nil || user.userID == nil || user.profile.email == "" || user.userID == "" || user.profile.name == nil || user.profile.name == ""){
           
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
            let fullName    = user.profile.name
            let fullNameArr = fullName?.components(separatedBy: " ")
            
            txt_first.text    = fullNameArr![0]
            txt_last.text = fullNameArr![1]
            //txt_password.text = user.userID
            
            //self.signUp(self)
        }
        
       
        
        
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
  
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func LoginGoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
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
