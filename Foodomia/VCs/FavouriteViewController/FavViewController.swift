//
//  FavViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/25/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD

class FavViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var myView: UIView!
  
    

    
    @IBOutlet var upperView: UIView!
    
    @IBOutlet weak var txt_location: UILabel!
    
    var filtered:NSMutableArray = []
    var MenuName:NSMutableArray = []
    var searchActive : Bool = false
    
    @IBOutlet weak var innerview: UIView!
    @IBOutlet weak var btn_close: UIButton!
    
    @IBOutlet weak var closeImage: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var searchbar: UITextField!
    
    var Resturantlist:NSMutableArray?
    var avglist:NSMutableArray = []
    var totalRatingslist:NSMutableArray = []
    @IBOutlet var tableview: UITableView!
    
    var loadingToggle:String? = "yes"
    var refreshControl = UIRefreshControl()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(RestuarntsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableview?.addSubview(refreshControl)
        
        Resturantlist = []
        self.getResturantsApi()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    
  
    
    @IBAction func searchClose(_ sender: Any) {
        btn_close.alpha = 0
        closeImage.alpha = 0
        searchbar.text = ""
        searchActive = false
        tableview.reloadData()
        searchbar.resignFirstResponder()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        btn_close.alpha = 1
        closeImage.alpha = 1
    }
    
    
    
    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
        self.getResturantsApi()
    }

    
    
    func getResturantsApi(){
        
        
        if(loadingToggle == "yes"){
            
            appDelegate.showActivityIndicatory(uiView:self.view)
            KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        }
        
        
        avglist = []
        totalRatingslist = []
        MenuName = []
        
        
        let url : String = appDelegate.baseUrl+appDelegate.showFavouriteRestaurants
        
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["user_id":defaults.string(forKey: "uid")!]
    
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
                    if(myCountry?.count == 0){
                    self.Resturantlist = []
                    }else{
                    
                    self.Resturantlist = []
                    print(myCountry!)
                    for Dict in myCountry! {
                        
                        let myRestaurant = Dict["Restaurant"] as! [String:Any]
                        let myRestaurant1 = myRestaurant["Currency"] as!  NSDictionary
                        let myRestaurant2 = myRestaurant["Tax"] as!  NSDictionary
                        var avgRating:String? = ""
                        var totalRating:String? = ""
                        if(Dict["TotalRatings"] != nil){
                            let myRating = Dict["TotalRatings"] as! [String:String]
                            avgRating = myRating["avg"]
                            totalRating = myRating["totalRatings"]
                        }
                        let about = myRestaurant["about"]
                        let delivery_fee = "0.00"
                        let image = myRestaurant["image"]
                        let id = myRestaurant["id"]
                        let menu_style = myRestaurant["menu_style"]
                        let name = myRestaurant["name"]
                        let phone = myRestaurant["phone"]
                        let slogan = myRestaurant["slogan"]
                        let cover_image = myRestaurant["cover_image"]
                        let currency = myRestaurant1["symbol"]
                        let tax = myRestaurant2["tax"]
                        let est_delivery = myRestaurant2["delivery_time"]
                        //let distance1 =  Dict["0"] as! [String:String]
                        let distance = "2534"
                        let preTime = myRestaurant["preparation_time"] as! String
                     
                        let delivery_fee_per_km = myRestaurant2["delivery_fee_per_km"]
                      let min_order_price = myRestaurant["min_order_price"]
                        var ResAddress = ""
                        if let myRestaurant3 = Dict["RestaurantLocation"] as? [String:String]{
                            
                            let a2:String! = myRestaurant3["city"]!
                            let b2:String! = myRestaurant3["country"]!
                            ResAddress = a2+" "+b2
                        }
                        let delivery_free_range = myRestaurant["delivery_free_range"]
                        let obj = Restuarant(about:about as! String, delivery_fee: delivery_fee as! String, image:image as! String , id:id as! String , menu_style:menu_style as! String , name:name as! String , phone:phone as! String , slogan:slogan as! String, totalRating:totalRating as! String, avgRating:avgRating as! String,isFav:"1" as! String,distance:distance as! String,cover_image:cover_image as! String,currency:currency as! String,tax:tax as! String,promote:"0",preTime:preTime,min_order_price:min_order_price as! String,delivery_fee_per_km: delivery_fee_per_km as! String,delivery_free_range: delivery_free_range as! String,ResAddress: ResAddress as! String,est_delivery:est_delivery as! String)
                        
                        self.Resturantlist?.add(obj)
                        //                        self.avglist.add(avg!)
                        //                         self.totalRatingslist.add(totalRatings!)
                        }
                        
                    }
                    
                    
                    if(self.Resturantlist?.count == 0){
                        self.innerview.alpha = 1
                        self.refreshControl.endRefreshing()
                        //self.alertModule(title:"Error", msg:"NO Restaurant Found.")
                    }else{
                        
                        self.innerview.alpha = 0
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                        self.refreshControl.endRefreshing()
                        self.tableview.reloadData()
                    }
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                self.refreshControl.endRefreshing()
                print(error)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive == true){
            return self.filtered.count
        }else{
            return self.Resturantlist!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(searchActive == true){
            
            return 110
        }else{
           
                return 110
      
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(searchActive == true){
            let cell:RTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell1") as! RTableViewCell
            
            let obj = self.filtered[indexPath.row] as! Restuarant
            let today : String!
            
            today = getTodayString()
            
            if(obj.min_order_price == "0.00"){
                cell.txt_minorder.text = obj.currency+obj.delivery_fee_per_km+"/km"
            }else{
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km- Free over "
                cell.txt_minorder.text = s+obj.currency+obj.min_order_price
                
                
            }
            cell.R_img.layer.masksToBounds = false
            cell.R_img.layer.cornerRadius = cell.R_img.frame.height/2
            cell.R_img.clipsToBounds = true
            cell.R_img.sd_setImage(with: URL(string:self.appDelegate.ImagebaseUrl+obj.image), placeholderImage: UIImage(named: "Unknown"))
            cell.txt_estFee.text = obj.est_delivery+" min"
          
            print(obj.slogan)
            
            cell.R_title.text = obj.name
            cell.R_description.text = obj.slogan
            cell.pre_time.text = obj.preTime+" min"
            //cell.rating_count.text = obj.currency+obj.delivery_fee
           
                
                cell.heart_img.image = UIImage(named: "heart")
            if(obj.avgRating == nil || obj.avgRating == ""){
                
                cell.rating_view.rating = 0.0000
                
            }else{
                cell.rating_view.rating = Double(obj.avgRating)!
            }
            cell.btn_favourite.tag = indexPath.row
            cell.btn_favourite.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            if(obj.isFav == "0"){
                
                cell.heart_img.image = UIImage(named: "Unheart")
            }else{
                
                cell.heart_img.image = UIImage(named: "heart")
            }
            
            return cell
      
            }else{
                
                let cell:RTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell1") as! RTableViewCell
                
                let obj = self.Resturantlist![indexPath.row] as! Restuarant
                let today : String!
                
                today = getTodayString()
            if(obj.isFav == "0"){
                
                cell.heart_img.image = UIImage(named: "Unheart")
            }else{
                
                cell.heart_img.image = UIImage(named: "heart")
            }
          
            if(obj.min_order_price == "0.00"){
                cell.txt_minorder.text = obj.currency+obj.delivery_fee_per_km+"/km"
            }else{
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km- Free over "
                cell.txt_minorder.text = s+obj.currency+obj.min_order_price
                
                
            }
           
                cell.R_img.layer.masksToBounds = false
                cell.R_img.layer.cornerRadius = cell.R_img.frame.height/2
                cell.R_img.clipsToBounds = true
                cell.R_img.sd_setImage(with: URL(string:self.appDelegate.ImagebaseUrl+obj.image), placeholderImage: UIImage(named: "Unknown"))
                
                cell.txt_estFee.text = obj.est_delivery+" min"
            
                print(obj.slogan)
                
                cell.R_title.text = obj.name
                cell.R_description.text = obj.slogan
                cell.pre_time.text = obj.preTime+" min"
                //cell.rating_count.text = obj.currency+obj.delivery_fee
                cell.heart_img.image = UIImage(named: "heart")
            if(obj.avgRating == nil || obj.avgRating == ""){
                
                cell.rating_view.rating = 0.0000
                
            }else{
                cell.rating_view.rating = Double(obj.avgRating)!
            }
            cell.btn_favourite.tag = indexPath.row
            cell.btn_favourite.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            
                return cell
                
            
            
        }
    }
    
    @objc func buttonClicked(sender: UIButton) {
        let buttonRow = sender.tag
        print(buttonRow+1)
        let indexPath = IndexPath(row:buttonRow, section:0)
        let obj =   Resturantlist![buttonRow] as! Restuarant
        let cell = tableview.cellForRow(at:indexPath) as! RTableViewCell
        if(cell.heart_img.image ==
            UIImage(named: "Unheart")){
            if(defaults.string(forKey: "uid") == nil || defaults.string(forKey: "uid") == ""){
                
            }else{
                cell.heart_img.image = UIImage(named: "heart")
                StaticData.singleton.Rest_id = obj.id
                StaticData.singleton.isFavourite = "1"
                AddFavourite()
            }
        }else{
            if(defaults.string(forKey: "uid") == nil || defaults.string(forKey: "uid") == ""){
                
            }else{
                cell.heart_img.image = UIImage(named: "Unheart")
                
                StaticData.singleton.Rest_id = obj.id
                StaticData.singleton.isFavourite = "0"
                AddFavourite()
            }
        }
        print(buttonRow)
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(searchActive == true){
            
            let obj = self.filtered[indexPath.row] as! Restuarant
            print(obj.name)
            StaticData.singleton.Rest_name = obj.name
            StaticData.singleton.Rest_id = obj.id
            StaticData.singleton.Rest_image = obj.image
            StaticData.singleton.Rest_Cimage = obj.cover_image
            StaticData.singleton.Rest_salogan = obj.slogan
            UserDefaults.standard.set(StaticData.singleton.Rest_name!, forKey: "rest")
            StaticData.singleton.Rest_rating = obj.avgRating
            StaticData.singleton.Rest_About = obj.about
             StaticData.singleton.currSymbol = obj.currency
            StaticData.singleton.restTax = obj.tax
            StaticData.singleton.restFee = obj.delivery_fee
            if(obj.delivery_free_range == "0"){
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km"
                StaticData.singleton.MenuDelFee = s
                
            }else{
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km - free delivery "+obj.currency+obj.min_order_price+" within "+obj.delivery_free_range+" km"
                StaticData.singleton.MenuDelFee = s
            }
            self.performSegue(withIdentifier:"resFav", sender: nil)
        }else{
          
                
                let obj = self.Resturantlist![indexPath.row] as! Restuarant
                print(obj.name)
            
                StaticData.singleton.Rest_name = obj.name
                StaticData.singleton.Rest_id = obj.id
                StaticData.singleton.Rest_image = obj.image
                StaticData.singleton.Rest_salogan = obj.slogan
                UserDefaults.standard.set(StaticData.singleton.Rest_name!, forKey: "rest")
                StaticData.singleton.Rest_Cimage = obj.cover_image
                StaticData.singleton.Rest_rating = obj.avgRating
                StaticData.singleton.Rest_About = obj.about
                StaticData.singleton.currSymbol = obj.currency
                StaticData.singleton.restTax = obj.tax
                StaticData.singleton.restFee = obj.delivery_fee
            if(obj.delivery_free_range == "0"){
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km"
                StaticData.singleton.MenuDelFee = s
                
            }else{
                let s:String! = obj.currency+obj.delivery_fee_per_km+"/km - free delivery "+obj.currency+obj.min_order_price+" within "+obj.delivery_free_range+" km"
                StaticData.singleton.MenuDelFee = s
            }
                self.performSegue(withIdentifier:"resFav", sender: nil)
            }
            
        
    }
    
    func AddFavourite(){
        
        appDelegate.showActivityIndicatory(uiView: myView)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        let url : String = appDelegate.baseUrl+appDelegate.addFavouriteRestaurant
        var parameter :[String:Any]?
        
        if(defaults.string(forKey: "uid") == nil || defaults.string(forKey: "uid") == ""){
            parameter = ["user_id":"","restaurant_id":StaticData.singleton.Rest_id!,"favourite":StaticData.singleton.isFavourite!]
        }else{
            
            parameter = ["user_id":defaults.string(forKey: "uid")!,"restaurant_id":StaticData.singleton.Rest_id!,"favourite":StaticData.singleton.isFavourite!]
        }
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                self.self.myView.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    self.getResturantsApi()
                    
                    
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
    
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //
    //        self.getResturantsApi()
    //    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let string1 = string
        let string2 = String(searchbar.text!)
        var finalString = ""
        if (string1.characters.count>0) { // if it was not delete character
            finalString = string2 + string1
        }
        else if (string2.characters.count > 0){ // if it was a delete character
            
            finalString = String(string2.characters.dropLast())
        }
        
        filteredArray(searchString: finalString as String)
        
        return true
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func filteredArray(searchString:String){// we will use NSPredicate to find the string in array
        self.filtered.removeAllObjects()
        if((self.Resturantlist?.count)! > 0){
            for i in 0...(Resturantlist?.count)!-1{
                let obj = Resturantlist![i] as! Restuarant
                if obj.name!.lowercased().range(of:searchString) != nil {
                    self.filtered.add(obj)
                }
            }
        }
        //let resultPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchString)
        // filtered = Resturantlist?.filtered(using: resultPredicate) as! NSArray
        
        print(filtered)
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableview.reloadData()
        
    }
    func getTodayString() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }


        
}

