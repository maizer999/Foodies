//
//  HotelRestaurantsVC.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD
import Foundation
import SystemConfiguration
import Firebase
import FirebaseDatabase

class HotelRestaurantsVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var myCart:[[String:Any]]? = [[:]]
    
    @IBOutlet weak var btn_filter: UIBarButtonItem!
    
    
    @IBOutlet weak var close_btn: UIButton!
    var filtered:NSMutableArray = []
    
    @IBOutlet weak var innerview: UIView!
     var searchActive : Bool = false
    
    var status:String! = "Current"
    
    @IBOutlet weak var img_close: UIImageView!
    @IBOutlet weak var txt_search: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var current_view: UIView!
    
    @IBOutlet weak var past_view: UIView!
    
    var refreshControl = UIRefreshControl()
    
    var loadingToggle:String? = "yes"
  
    var toggle:String? = "yes"
    var Pending:NSMutableArray = []
    var Accept:NSMutableArray = []
    
    var childRef0 = FIRDatabase.database().reference().child("restaurant").child(UserDefaults.standard.string(forKey: "uid")!).child("CurrentOrders")
    var childRef1 = FIRDatabase.database().reference().child("restaurant").child(UserDefaults.standard.string(forKey: "uid")!).child("PendingOrders")
    
    var Sections:NSMutableArray = ["CURRENT ORDERS"]
    
    var menuItemList:NSMutableArray = []
    var ExtramenuItemList:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(RestuarntsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableview?.addSubview(refreshControl)
        
        
        
        
        //self.tabBarController?.tabBar.isUserInteractionEnabled = false;
        self.OrderApi()
    }
    
    
    
    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
        self.OrderApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Orders"
        
        if(StaticData.singleton.isRESReload == "yes"){
            loadingToggle = "yes"
            StaticData.singleton.isRESReload = ""
            self.OrderApi()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func OrderApi(){
        
        let isValid:Bool = self.isInternetAvailable()
        
        if(isValid){
            if(loadingToggle == "yes"){
              
                KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
            }
        if(status == "Current"){
            
            childRef0.observe(.value) { (snapshot) in
                self.Pending = []
              
                if snapshot.childrenCount > 0 {
                  
                   
                    for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        let artistObject = artists.value as? [String: AnyObject]
                        let key = artists.key
                        print(artistObject!)
                        let order_id = artistObject?["order_id"] as! String
                        let order_status = artistObject?["status"] as! String
                        let order_deal = artistObject?["deal"] as! String
                        let type = artistObject?["type"] as! String
                        
                        let obj = HotelSide(order_id:order_id, order_status:order_status, order_deal:order_deal,key:key,type:type)
                        self.Pending.add(obj)
                    }
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                     self.Pending =  NSMutableArray(array: self.Pending.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
                    self.innerview.alpha = 0
                    
                    self.toggle = "no"
                    self.refreshControl.endRefreshing()
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
                }else{
                    self.Pending = []
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                   
                  
                        
                        self.innerview.alpha = 1
                        self.refreshControl.endRefreshing()
                    
                
                }
            }
        }else{
            
            childRef1.observe(.value) { (snapshot) in
                self.Accept = []
                
                
                if snapshot.childrenCount > 0 {
                    
                    for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        let artistObject = artists.value as? [String: AnyObject]
                        print(artistObject!)
                       
                        let key = artists.key
                        print(artistObject!)
                        let order_id = artistObject?["order_id"] as! String
                        let order_status = artistObject?["status"] as! String
                        let order_deal = artistObject?["deal"] as! String
                        let type = artistObject?["type"] as! String
                        
                        let obj = HotelSide(order_id:order_id, order_status:order_status, order_deal:order_deal,key:key,type:type)
                        self.Accept.add(obj)
                    }
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                    self.Accept =  NSMutableArray(array: self.Accept.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
                    self.innerview.alpha = 0
                    
                    self.toggle = "no"
                    self.refreshControl.endRefreshing()
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
                }else{
                    self.Accept = []
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                    
                
                        
                        self.innerview.alpha = 1
                        self.refreshControl.endRefreshing()
                    
                
                }
                }
        }
        }else{
            self.innerview.alpha = 0
            self.alertModule(title:"Error", msg:"The Internet connection appears to be offline.")
        }
        
    }
    
    @objc func loaded()
    {
        Loader.removeLoaderFrom(tableview)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int  {
        
        return Sections.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        
            if(self.status == "Current"){
                if(searchActive == true){
                    return filtered.count
                }else{
                    return Pending.count
                    
                }
            }else{
                if(searchActive == true){
                    return filtered.count
                }else{
                    return Accept.count
                    
                }
                
            }
    
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        
        return self.Sections[section] as! String
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.init(red:235/255.0, green:235/255.0, blue:235/255.0, alpha: 1.0)
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y:10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        headerLabel.font = UIFont.systemFont(ofSize:12, weight:UIFont.Weight.regular)
        headerLabel.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
        
        headerLabel.text = self.tableView(self.tableview, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.status == "Current"){
            let cell:MyCell = self.tableview.dequeueReusableCell(withIdentifier: "cell77") as! MyCell
            if(searchActive == true){
             
            
           
        let obj1 = filtered[indexPath.row] as! HotelSide
                if(obj1.type == "0"){
           
            cell.orderNo.text = "Order# "+obj1.order_id+" (Pickup)"
            }else{
                
                cell.orderNo.text = "Order# "+obj1.order_id
            }
            if(obj1.order_status == "0"){
                cell.order_status.alpha = 1
                cell.deal_img.alpha = 0
                
            }else{
                cell.order_status.alpha = 0
                if(obj1.order_deal == "1"){
                    cell.deal_img.alpha = 1
                }else{
                    
                    cell.deal_img.alpha = 0
                }
            }
            
            }else{
                
                let obj1 = Pending[indexPath.row] as! HotelSide
                
                if(obj1.type == "0"){
                    
                    cell.orderNo.text = "Order# "+obj1.order_id+" (Pickup)"
                }else{
                    
                    cell.orderNo.text = "Order# "+obj1.order_id
                }
                if(obj1.order_status == "0"){
                    cell.order_status.alpha = 1
                    cell.deal_img.alpha = 0
                    
                }else{
                    cell.order_status.alpha = 0
                    if(obj1.order_deal == "1"){
                        cell.deal_img.alpha = 1
                    }else{
                        
                        cell.deal_img.alpha = 0
                    }
                }
            }
        
        return cell
        }else{
             let cell:MyCell = self.tableview.dequeueReusableCell(withIdentifier: "cell77") as! MyCell
            
            if(searchActive == true){
            let obj1 = filtered[indexPath.row] as! HotelSide
            
                if(obj1.type == "0"){
                    
                    cell.orderNo.text = "Order# "+obj1.order_id+" (Pickup)"
                }else{
                    
                    cell.orderNo.text = "Order# "+obj1.order_id
                }
            if(obj1.order_status == "0"){
                cell.order_status.alpha = 1
                cell.deal_img.alpha = 0
                
            }else{
                cell.order_status.alpha = 0
                if(obj1.order_deal == "1"){
                    cell.deal_img.alpha = 1
                }else{
                    
                    cell.deal_img.alpha = 0
                }
                
            }
            }else{
                let obj1 = Accept[indexPath.row] as! HotelSide
                
                if(obj1.type == "0"){
                    
                    cell.orderNo.text = "Order# "+obj1.order_id+" (Pickup)"
                }else{
                    
                    cell.orderNo.text = "Order# "+obj1.order_id
                }
                if(obj1.order_status == "0"){
                    cell.order_status.alpha = 1
                    cell.deal_img.alpha = 0
                    
                }else{
                    cell.order_status.alpha = 0
                    if(obj1.order_deal == "1"){
                        cell.deal_img.alpha = 1
                    }else{
                        
                        cell.deal_img.alpha = 0
                    }
                    
                }
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(self.status == "Current"){
             if(searchActive == true){
        let obj1 = filtered[indexPath.row] as! HotelSide
       
       
        StaticData.singleton.OrderId = obj1.order_id
        StaticData.singleton.hotel_key  = obj1.key
        
        StaticData.singleton.isRESDetail = "yes"
            childRef0.observeSingleEvent(of:.value, with: { (snapshot) in
               
                if snapshot.childrenCount > 0 {
                    for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        let artistObject = artists.value as? [String: AnyObject]
                        let key = artists.key
                        
                        let order_id = artistObject?["order_id"] as! String
                        
                        let order_deal = artistObject?["deal"] as! String
                        let type = artistObject?["type"] as! String
                        if(obj1.key == key){
                            let message = ["order_id":order_id ,"status":"1","deal":order_deal,"type":type] as [String : Any]
                            self.childRef0.child(key).updateChildValues(message)
                        }
                    }
                }
            })
        
        self.performSegue(withIdentifier:"showRESDetails", sender:self)
             }else{
                let obj1 = Pending[indexPath.row] as! HotelSide
                
                
                StaticData.singleton.OrderId = obj1.order_id
                StaticData.singleton.hotel_key  = obj1.key
                
                StaticData.singleton.isRESDetail = "yes"
                childRef0.observeSingleEvent(of:.value, with: { (snapshot) in
                    
                    if snapshot.childrenCount > 0 {
                        for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                            let artistObject = artists.value as? [String: AnyObject]
                            let key = artists.key
                            
                            let order_id = artistObject?["order_id"] as! String
                            
                            let order_deal = artistObject?["deal"] as! String
                            let type = artistObject?["type"] as! String
                            if(obj1.key == key){
                                let message = ["order_id":order_id ,"status":"1","deal":order_deal,"type":type] as [String : Any]
                                self.childRef0.child(key).updateChildValues(message)
                            }
                        }
                    }
                })
                
                self.performSegue(withIdentifier:"showRESDetails", sender:self)
            }
            
        }else{
            if(searchActive == true){
            let obj1 = filtered[indexPath.row] as! HotelSide
          
           StaticData.singleton.OrderId = obj1.order_id
            StaticData.singleton.isRESDetail = "no"
            StaticData.singleton.hotel_key  = obj1.key
            childRef1.observeSingleEvent(of:.value, with: { (snapshot) in
                
                if snapshot.childrenCount > 0 {
                    for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        let artistObject = artists.value as? [String: AnyObject]
                        let key = artists.key
                        let order_id = artistObject?["order_id"] as! String
                        
                        let order_deal = artistObject?["deal"] as! String
                        let type = artistObject?["type"] as! String
                        if(obj1.key == key){
                            let message = ["order_id":order_id ,"status":"1","deal":order_deal,"type":type] as [String : Any]
                            self.childRef1.child(key).updateChildValues(message)
                        }
                    }
                }
            })
            
            self.performSegue(withIdentifier:"showRESDetails", sender:self)
            }
            
        else{
            let obj1 = Accept[indexPath.row] as! HotelSide
            
            StaticData.singleton.OrderId = obj1.order_id
            StaticData.singleton.isRESDetail = "no"
            StaticData.singleton.hotel_key  = obj1.key
            childRef1.observeSingleEvent(of:.value, with: { (snapshot) in
                
                if snapshot.childrenCount > 0 {
                    for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        let artistObject = artists.value as? [String: AnyObject]
                        let key = artists.key
                        let order_id = artistObject?["order_id"] as! String
                        
                        let order_deal = artistObject?["deal"] as! String
                        let type = artistObject?["type"] as! String
                        if(obj1.key == key){
                            let message = ["order_id":order_id ,"status":"1","deal":order_deal,"type":type] as [String : Any]
                            self.childRef1.child(key).updateChildValues(message)
                        }
                    }
                }
            })
            
            self.performSegue(withIdentifier:"showRESDetails", sender:self)
            }
        }
    }
    
    
    
    
    
    
    
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
    
    @IBAction func Filterorder(_ sender: Any) {
        let sheet = UIAlertController(title: "Order Filter", message:nil, preferredStyle: .actionSheet) // Initialize action sheet type
        
        let Bank = UIAlertAction(title: "Current Orders", style: .default, handler: { action in
            // Presents picker
            self.status = "Current"
            self.Sections.removeAllObjects()
            self.Sections = ["Current Orders"]
            self.OrderApi()
            
        })
        
        let MRS = UIAlertAction(title: "Accepted Orders", style: .default, handler: { action in
            // Presents picker
            
            self.status = "Accepted"
            self.Sections.removeAllObjects()
            self.Sections = ["Accepted Orders"]
            self.OrderApi()
           
            
        })
        
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            // Presents picker
            sheet.hidesBottomBarWhenPushed = true
        })
       
        
        // Add actions
        sheet.addAction(Bank)
        sheet.addAction(MRS)
        sheet.addAction(Cancel)
        if ( UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            if let popoverPresentationController = sheet.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0,y: self.view.bounds.size.height / 2.0, width:1.0, height:1.0)
                present(sheet, animated: true, completion: nil)
            }
        }else{
            present(sheet, animated: true, completion: nil)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let string1 = string
        let string2 = String(txt_search.text!)
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
        if(self.status == "Current"){
        if((self.Pending.count) > 0){
            for i in 0...(Pending.count)-1{
                let obj = Pending[i] as! HotelSide
                if obj.order_id.lowercased().range(of:searchString) != nil {
                    self.filtered.add(obj)
                }
            }
        }
        }else{
            if((self.Accept.count) > 0){
                for i in 0...(Accept.count)-1{
                    let obj = Accept[i] as! HotelSide
                    if obj.order_id.lowercased().range(of:searchString) != nil {
                        self.filtered.add(obj)
                    }
                }
            }
            
        }
     
        print(filtered)
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableview.reloadData()
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        close_btn.alpha = 1
        img_close.alpha = 1
    }

    @IBAction func cross(_ sender: Any) {
        close_btn.alpha = 0
        img_close.alpha = 0
        txt_search.text = ""
        searchActive = false
        tableview.reloadData()
        txt_search.resignFirstResponder()
    }
}
