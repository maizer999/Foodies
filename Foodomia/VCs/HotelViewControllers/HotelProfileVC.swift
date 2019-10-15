//
//  HotelProfileVC.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON

class HotelProfileVC: UIViewController,UIWebViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var innerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        self.title = "Profile"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func profile(_ sender: Any) {
        
        StaticData.singleton.Profile_status = "NO"
        self.performSegue(withIdentifier: "profileShow", sender: self)
    }

    @IBAction func WeeklyEarning(_ sender: Any) {
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.title = "Weekly Earnings"
        
        innerView.isHidden = false
        
         let urlString = "http://restaurants.foodomia.pk/login.php?device=app"
        
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
        
        let urlString = "https://restaurants.foodomia.pk/dashboard.php?p=appHelp&device=app"
        
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            webView.loadRequest(request)
        }
        
    }
    
    
    
    @IBAction func close(_ sender: Any) {
        
        self.title = "Profile"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
        innerView.isHidden = true
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

