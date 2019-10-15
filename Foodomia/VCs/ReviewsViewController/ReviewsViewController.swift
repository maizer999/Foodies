//
//  ReviewsViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/26/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD

class ReviewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet var reviewcount: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var ReviewsList:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewcount.text = "NO"+" REVIEWS"
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        if(StaticData.singleton.isReviews == "Hotel"){
        self.getReviewsApi()
        }else{
            self.getRiderReviewsApi()
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getReviewsApi(){
        
        ReviewsList = []
        appDelegate.showActivityIndicatory(uiView: self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let url : String = appDelegate.baseUrl+appDelegate.restaurantRatings
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["restaurant_id":StaticData.singleton.Rest_id!]
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
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
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                   
                    for Dict in myCountry! {
                        let comments = Dict["comments"] as? [[String:Any]]
                        for dictionay in comments! {
                        let mycomments = dictionay["RestaurantRating"] as? [String:String]
                        let mycomments1 = dictionay["UserInfo"] as? [String:String]
                            let id = mycomments!["id"]
                            let comment = mycomments!["comment"]
                            let reviewname = mycomments1!["first_name"]!+" "+mycomments1!["last_name"]!
                            let reviewRating = mycomments!["star"]
                            let reviewTime = mycomments!["created"]
                            let obj = Review(id:id as! String as! String ,comment:comment as! String,reviewname:reviewname as! String,reviewRating:reviewRating as! String,reviewTime:reviewTime as! String)
                        
                        self.ReviewsList.add(obj)
                        }
                     
                    }
                        
                
                    
                    if(self.ReviewsList.count == 0){
                        
                        //self.alertModule(title:"Error", msg:"NO Reviews Found.")
                        self.reviewcount.text = "NO"+" REVIEWS"
                        self.innerView.alpha = 1
                    }else{
                        
                        self.reviewcount.text = String(self.ReviewsList.count)+" REVIEWS"
                        self.innerView.alpha = 0
                        self.tableview.reloadData()
                    }
                    
                }else{
                    
                   
                   self.innerView.alpha = 1
                    
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
    
    func getRiderReviewsApi(){
        
        ReviewsList = []
        appDelegate.showActivityIndicatory(uiView: self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let url : String = appDelegate.baseUrl+appDelegate.showRiderRatings
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!]
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
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
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                    print(myCountry!)
                    
                    for Dict in myCountry! {
                        let comments = Dict["comments"] as? [[String:Any]]
                        for dictionay in comments! {
                            let mycomments = dictionay["RiderRating"] as? [String:String]
                            let mycomments1 = dictionay["UserInfo"] as? [String:String]
                            let id = mycomments!["id"]
                            let comment = mycomments!["comment"]
                            let reviewname = mycomments1!["first_name"]!+" "+mycomments1!["last_name"]!
                            let reviewRating = mycomments!["star"]
                            let reviewTime = mycomments!["created"]
                            let obj = Review(id:id as! String as! String ,comment:comment as! String,reviewname:reviewname as! String,reviewRating:reviewRating as! String,reviewTime:reviewTime as! String)
                            
                            self.ReviewsList.add(obj)
                        }
                        
                    }
                    
                    
                    
                    if(self.ReviewsList.count == 0){
                        
                        //self.alertModule(title:"Error", msg:"NO Reviews Found.")
                        self.reviewcount.text = "NO"+" REVIEWS"
                        self.innerView.alpha = 1
                    }else{
                        
                        self.reviewcount.text = String(self.ReviewsList.count)+" REVIEWS"
                        self.innerView.alpha = 0
                        self.tableview.reloadData()
                    }
                    
                }else{
                    
                    
                    self.innerView.alpha = 1
                    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ReviewsList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:ReviewTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell3") as! ReviewTableViewCell
        let obj = self.ReviewsList[indexPath.row] as! Review
        
        cell.review_name.text = obj.reviewname
        cell.review_description.text = obj.comment
        cell.review_time.text = obj.reviewTime
        if(obj.reviewRating == nil || obj.reviewRating == ""){
            
            cell.rRatings.rating = 0.0000
            
        }else{
            cell.rRatings.rating = Double(obj.reviewRating)!
        }
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       
//    }
    func timeCalculate(dateString:String) -> String{
        
        let calendar = Calendar.current
        
        let firstDate  = NSDate() // Current date
        // Get input(date) from textfield
        
        let isoDate = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:isoDate)!
        
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let secondDate = calendar.date(from:components)
        
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < secondDate! {
            let diff = Calendar.current.dateComponents([.second], from: secondDate!, to: Date()).second ?? 0
            if(diff == 1){
                return "\(diff) second ago"
            }else{
                return "\(diff) seconds ago"
            }
        } else if hourAgo < secondDate! {
            let diff = Calendar.current.dateComponents([.minute], from: secondDate!, to: Date()).minute ?? 0
            if(diff == 1){
                return "\(diff) minute ago"
            }else{
                return "\(diff) minutes ago"
                
            }
        } else if dayAgo < secondDate! {
            let diff = Calendar.current.dateComponents([.hour], from: secondDate!, to: Date()).hour ?? 0
            if(diff == 1){
                return "\(diff) hour ago"
            }else{
                return "\(diff) hours ago"
                
            }
            
        } else if weekAgo < secondDate! {
            let diff = Calendar.current.dateComponents([.day], from: secondDate!, to: Date()).day ?? 0
            if(diff == 1){
                return "\(diff) day ago"
            }else{
                return "\(diff) days ago"
                
            }
            
        }else{
            let diff = Calendar.current.dateComponents([.weekOfYear], from: secondDate!, to: Date()).weekOfYear ?? 0
            if(diff == 1){
                return "\(diff) week ago"
            }else{
                return "\(diff) weeks ago"
                
            }
            
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

}
