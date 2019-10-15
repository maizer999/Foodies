//
//  MyAccountViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/29/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON

class MyAccountViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var myInnerView: UIView!
    
    @IBOutlet weak var Username: UILabel!
    @IBOutlet var webView: UIWebView!
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var innerView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear

        if(UserDefaults.standard.string(forKey:"isLogin")=="YES"){
            
            Username.text = "\(UserDefaults.standard.string(forKey: "first_name")!) \(UserDefaults.standard.string(forKey: "last_name")!)"
          
            myInnerView.isHidden = true
        }else if(UserDefaults.standard.string(forKey:"isLogin")=="NO"){
            
            myInnerView.isHidden = false
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Account"
          Username.text = "\(UserDefaults.standard.string(forKey: "first_name")!) \(UserDefaults.standard.string(forKey: "last_name")!)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Terms(_ sender: Any) {
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
       innerView2.alpha = 1
        self.title = "Privacy Policy"
        
        
        let urlString = "https://foodomia.pk/privacy.php?device=app"
        
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            webView.loadRequest(request)
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        appDelegate.showActivityIndicatory(uiView:innerView2)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        innerView2.isUserInteractionEnabled = true
        KRProgressHUD.dismiss {
            print("dismiss() completion handler.")
        }
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        innerView2.isUserInteractionEnabled = true
        KRProgressHUD.dismiss {
            print("dismiss() completion handler.")
        }
    }

    @IBAction func close(_ sender: Any) {
        
        self.title = "Account"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
    innerView2.alpha = 0
        innerView2.isUserInteractionEnabled = true
    }
    @IBAction func Logout(_ sender: Any) {
        
        UserDefaults.standard.set("NO", forKey:"isLogin")

        UserDefaults.standard.set("", forKey:"email")
        UserDefaults.standard.set("", forKey:"pwd")
        UserDefaults.standard.set("", forKey:"uid")
        UserDefaults.standard.set("", forKey:"first_name")
        UserDefaults.standard.set("", forKey:"last_name")
        UserDefaults.standard.set("", forKey:"contactNO")
        UserDefaults.standard.set("", forKey:"aid")
        UserDefaults.standard.set("", forKey:"UserType")
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
    }
    
    @IBAction func UAN(_ sender: Any) {
        if let phoneCallURL = URL(string: "tel://03111444245") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    

}
