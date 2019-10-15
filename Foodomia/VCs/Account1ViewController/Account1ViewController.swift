//
//  Account1ViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/29/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD
import Cosmos

class Account1ViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var rest_img: UIImageView!
    
    @IBOutlet weak var rest_name: UILabel!
    
    @IBOutlet weak var rest_rat: CosmosView!
    
    @IBOutlet weak var txt_review: UITextView!
    var count:Float = 0.0
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var editView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        rest_rat.didTouchCosmos = didTouchCosmos
        rest_rat.rating = 0.0
        txt_review.delegate = self
        txt_review.text = "Type Your Reviews"
        txt_review.textColor = UIColor.lightGray
        self.editView.layer.borderWidth = 1
        self.editView.layer.borderColor = UIColor.init(red:235/255.0, green:235/255.0, blue:235/255.0, alpha: 1.0).cgColor
        rest_img.layer.masksToBounds = false
        rest_img.layer.cornerRadius = rest_img.frame.height/2
        rest_img.clipsToBounds = true
        rest_name.text = UserDefaults.standard.string(forKey:"notiName")!
        print(self.appDelegate.ImagebaseUrl+UserDefaults.standard.string(forKey:"notiImg")!)
        rest_img.sd_setImage(with: URL(string:self.appDelegate.ImagebaseUrl+UserDefaults.standard.string(forKey:"notiImg")!), placeholderImage: UIImage(named: "Unknown"))
        
//         rest_rat.addTarget(self, action: #selector(buttonClicked(sender:)), for: .valueChanged)

        // Do any additional setup after loading the view.
    }
    
    private func didTouchCosmos(_ rating: Double) {
        rest_rat.rating = rating
        count = Float(rating)
        print(count)
        
        
    }
    
//    @objc func buttonClicked(sender:CosmosView) {
//        
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type Your Reviews"
            textView.textColor = UIColor.lightGray
        }
    }
    
 
   
    @IBAction func Done(_ sender: Any) {
        
        UserDefaults.standard.set("No", forKey:"isReview")
        
        self.dismiss(animated:true, completion:nil)
    }
    
    func AddReview(){
        
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let url : String = appDelegate.baseUrl+appDelegate.addRestaurantRating
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"restaurant_id":UserDefaults.standard.string(forKey: "notiRest")!,"comment":txt_review.text,"star":String(count)]
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
                
                    
                    UserDefaults.standard.set("No", forKey:"isReview")
                    
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
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func submit(_ sender: Any) {

        if(txt_review.text == "Type Your Reviews"){
            
            self.alertModule(title:"Error", msg:"Please enter your Comments.")
        }else{
            
            self.AddReview()
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
