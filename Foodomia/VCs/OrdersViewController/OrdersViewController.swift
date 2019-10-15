//
//  OrdersViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/25/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON
import SDWebImage
import KRProgressHUD
import Firebase
import FirebaseDatabase
import SystemConfiguration
import PopupDialog


class OrdersViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
     var childRef1 = FIRDatabase.database().reference().child("Calculation").child(UserDefaults.standard.string(forKey:"udid")!);
  
    var menuArray:NSMutableArray = []
    
    var filtered  = [Menu]()
    
    var open:String! = "1"
    
    @IBOutlet weak var sugessionView: UIView!
    
    @IBOutlet weak var sugessionTable: UITableView!
    
    @IBOutlet weak var close_image: UIImageView!
    
    @IBOutlet weak var close_btn: UIButton!
    
   
    
    @IBOutlet var tableview: UITableView!
    var searchActive : Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    var notificaionArray = [Menu]()
    var menuItemList:NSMutableArray = []

    
    @IBOutlet var searchbar: UITextField!
    
 
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        tableview.estimatedRowHeight = 68.0
        tableview.rowHeight = UITableViewAutomaticDimension
        
        tableview.delegate = self
        tableview.dataSource = self
        
        searchbar.delegate = self
        
        self.getMeuesApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        
        StaticData.singleton.isReviews = "Hotel"
        
        self.title = StaticData.singleton.Rest_name
        StaticData.singleton.whatsDeal = "no"
        self.view.isUserInteractionEnabled = true
        let childRef11 = FIRDatabase.database().reference().child("Cart");
        childRef11.child(UserDefaults.standard.string(forKey:"udid")!).observeSingleEvent(of:.value, with: { (snapshot) in
            
            
            if snapshot.childrenCount > 0 {
                self.tabBarController?.tabBar.items?[3].badgeValue = String(snapshot.childrenCount)
            }else{
                self.tabBarController?.tabBar.items?[3].badgeValue = nil
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMeuesApi(){
    
       // menulist = []
        menuItemList = []
        menuArray = []
       
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        appDelegate.showActivityIndicatory(uiView:self.view)
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let url : String = appDelegate.baseUrl+appDelegate.showRestaurantsMenu
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["id":StaticData.singleton.Rest_id!,"current_time":result]
       // print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters:parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                let tempMenuObj1 = Menu()
                tempMenuObj1.id = "abc"
                tempMenuObj1.name = "abc"
                tempMenuObj1.mydescription = "abc"
                var tempProductList1 = Itemlist()
                tempProductList1.id1 = "abc"
                tempProductList1.name1 = "abc"
                tempProductList1.description1 = "abc"
                tempProductList1.price1 = "abc"
                tempMenuObj1.listOfProducts.append(tempProductList1)
                self.notificaionArray.append(tempMenuObj1)
                
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
                    
                    let myRestaurant1 = myCountry! as NSArray
                    let myRestaurant2 = myRestaurant1[0] as! NSDictionary
                    let myRestaurant3 = myRestaurant2["Restaurant"] as! NSDictionary
                    self.open = myRestaurant3["open"] as! String
                    print(self.open)
                    
                    
                   
                    for Dict in myCountry! {
                     
                        let myRestaurant = Dict["RestaurantMenu"] as! NSArray
                        if(myRestaurant == nil || myRestaurant.count == 0){}else{
                        for i in 0...myRestaurant.count-1{
                             let tempMenuObj = Menu()
                            let dic1 = myRestaurant[i] as! [String:Any]
                            print(dic1)
                            tempMenuObj.id = dic1["id"] as? String
                            tempMenuObj.name = dic1["name"] as? String
                            self.menuArray.add(dic1["name"] as? String)
                            tempMenuObj.mydescription = dic1["description"] as? String
                            
//                            let obj = Menu(id:id!, name:name!, mydescription:mydescription!)
//                            self.menulist.add(obj)
                            let RestaurantMenuItem = dic1["RestaurantMenuItem"] as! NSArray
                            if(RestaurantMenuItem == nil || RestaurantMenuItem.count == 0){}else{
                           var tempProductList = Itemlist()
                            for j in 0...RestaurantMenuItem.count-1{
                                let dic2 = RestaurantMenuItem[j] as! [String:Any]
                            
                                tempProductList.id1 = dic2["id"] as! String
                                tempProductList.name1 = dic2["name"] as! String
                           tempProductList.description1 = dic2["description"] as! String
                           tempProductList.price1 = dic2["price"] as! String
                            tempProductList.orderStatus1 = dic2["out_of_order"] as? String
                            tempMenuObj.listOfProducts.append(tempProductList)
                            }
                        }
                            self.notificaionArray.append(tempMenuObj)
                    }
            }
                       
            
                        
    }
                    
                    print(self.notificaionArray.count)
                    print(self.menuItemList.count)
                    print(self.menuArray.count)
                  
                   
                    if(self.notificaionArray.count == 0){
                        
                       // self.alertModule(title:"Error", msg:"NO Menu Found.")
                        
                       // self.innerview.alpha = 1
                    }else{
                        
                         //self.innerview.alpha = 0
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                        self.tableview.reloadData()
                       
                    }
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                if(error.localizedDescription == "The network connection was lost."){
                   self.getMeuesApi()
                }else{
                    
                self.alertModule(title:"Error",msg:error.localizedDescription)
                }
                print(error.localizedDescription)
                
                
                //self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        close_image.alpha = 1
        close_btn.alpha = 1
        self.sugessionView.alpha = 1
        self.sugessionTable.delegate = self
        self.sugessionTable.dataSource = self
        self.sugessionTable.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == sugessionTable){
            
            return 1
        }else{
        if(searchActive == true){
            return filtered.count
        }else{
            
            
           return notificaionArray.count
        }
        }
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(tableView == sugessionTable){
            
            return menuArray.count
        }else{
        if(searchActive == true){
            return filtered[section].listOfProducts.count
        }else{
            
            if(section == 0){
                
                return 1
                
            }else{
                
              return notificaionArray[section].listOfProducts.count
            }
            
           
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView == sugessionTable){
            
            return 44
        }else{
        if(indexPath.section == 0){
            if(searchActive == true){
                return
              UITableViewAutomaticDimension
            }else{
            return 254
            }
            }else{
           
            return UITableViewAutomaticDimension
        }
        }
    }
    
    
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    if(tableView == sugessionTable){
        
        return 35
    }else{
    if(section == 0){
        if(searchActive == true){
            return 60
        }else{
        return 0
        }
    }else{
        return 60
    }
    }
    
    }
    
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if(tableView == sugessionTable){
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.init(red:235/255.0, green:235/255.0, blue:235/255.0, alpha: 1.0)
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y:10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        headerLabel.font = UIFont.systemFont(ofSize:12, weight:UIFont.Weight.regular)
        headerLabel.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
        
        headerLabel.text = "SUGGESTIONS"
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }else{
        let headerView = UIView()
        headerView.backgroundColor = UIColor.init(red:242/255.0, green:242/255.0, blue:242/255.0, alpha: 1.0)
        print()
        let headerLabel = UILabel(frame: CGRect(x: 15, y:10, width:
            tableView.bounds.size.width-15, height: tableView.bounds.size.height))
    let headerLabel2 = UILabel(frame: CGRect(x: 15, y:30, width:
       tableView.frame.size.width-15, height: tableView.bounds.size.height))
        headerLabel2.lineBreakMode = .byWordWrapping
        headerLabel2.numberOfLines = 0
        headerLabel2.adjustsFontSizeToFitWidth = true
    headerLabel.font  = UIFont (name: "Verdana", size:15)
        headerLabel.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
        headerLabel2.font = UIFont (name: "Verdana", size:12)
        headerLabel2.textColor = UIColor.lightGray
        if section < notificaionArray.count{
            if(searchActive == true){
                let obj = filtered[section]
                let newString = obj.name.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
                
                headerLabel.text = newString
                
            }else{
                let obj = notificaionArray[section]
                let newString = obj.name.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
                
                headerLabel.text = newString
            }
            
            
        }
        
    if(searchActive == true){
        if section < filtered.count {
            
            let obj = filtered[section]
            let newString = obj.mydescription.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
            
            headerLabel2.text = newString
        }
       
        }else{
        if section < notificaionArray.count {
            
            let obj = notificaionArray[section]
            let newString = obj.mydescription.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
            
            headerLabel2.text = newString
        }
            
        }
   
    
    
        headerLabel.sizeToFit()
        headerLabel2.sizeToFit()
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerLabel2)
        
        return headerView
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if(searchActive == true){

            if section < filtered.count {

                let obj = filtered[section]
                print(obj.name)
                let newString = obj.name.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
                return newString

            }
        }else{
    if section < notificaionArray.count {

            let obj = notificaionArray[section]
            print(obj.name)
        let newString = obj.name.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
        return newString
            }
    }
}


    return nil
}
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == sugessionTable){
            print(menuArray.count)
            let cell:UITableViewCell = (sugessionTable.dequeueReusableCell(withIdentifier: "cell0009"))!
           cell.textLabel?.font =  UIFont(name: "Verdana", size: 14)
            cell.textLabel?.text = menuArray[indexPath.row] as? String
            return cell
        }else{
        if(searchActive == true){
            
            let cell:OrderTableViewCell = tableview.dequeueReusableCell(withIdentifier: "cell2") as! OrderTableViewCell
            let obj:Itemlist = filtered[indexPath.section].listOfProducts[indexPath.row]
            let newString1 = obj.name1.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
            
            cell.order_name.text = newString1
            if(obj.orderStatus1 == "0"){
            cell.order_price.text = StaticData.singleton.currSymbol!+obj.price1
            }else{
                
                 cell.order_price.font  = UIFont (name: "Verdana", size:10)
               cell.order_price.text = "Out Of Order"
            
            }
            let newString = obj.description1.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
            
            cell.order_description.text = newString
            
            
            
            return cell
        }else{
            
            if(indexPath.section == 0){
                let cell:OrderUpperCellTableViewCell = tableview.dequeueReusableCell(withIdentifier: "cell49") as! OrderUpperCellTableViewCell
                if(self.open == "0"){
                    
                    cell.innerView.alpha = 1
                }else{
                    cell.innerView.alpha = 0
                }
               
              cell.de_fee.text = StaticData.singleton.MenuDelFee
                cell.name.text = StaticData.singleton.Rest_name
                
                       cell.salogan.text = StaticData.singleton.Rest_salogan
                
                   let str:String! = StaticData.singleton.Rest_rating
                        if(str==nil||str==""){
                            cell.rating_view.rating = 0.0000
                        }else{
                        cell.rating_view.rating = Double(str)!
                        }
       print(self.appDelegate.ImagebaseUrl+StaticData.singleton.Rest_Cimage!)
                       cell.restImage.sd_setImage(with: URL(string:self.appDelegate.ImagebaseUrl+StaticData.singleton.Rest_Cimage!), placeholderImage: UIImage(named: "Unknown"))
                cell.logo_image.layer.masksToBounds = false
                cell.logo_image.layer.cornerRadius =  cell.logo_image.frame.height/2
                cell.logo_image.clipsToBounds = true
                cell.logo_image.sd_setImage(with: URL(string:self.appDelegate.ImagebaseUrl+StaticData.singleton.Rest_image!), placeholderImage: UIImage(named: "Unknown"))
             //cell.btn_about.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
                 return cell
            }else{
           let cell:OrderTableViewCell = tableview.dequeueReusableCell(withIdentifier: "cell2") as! OrderTableViewCell
            let obj:Itemlist = notificaionArray[indexPath.section].listOfProducts[indexPath.row]
           
                let newString1 = obj.name1.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
                
                 cell.order_name.text = newString1
                if(obj.orderStatus1 == "0"){
                    cell.order_price.text = StaticData.singleton.currSymbol!+obj.price1
                }else{
                    cell.order_price.font  = UIFont (name: "Verdana", size:10)
                    cell.order_price.text = "Out Of Order"
                    
                }
                let newString = obj.description1.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
            cell.order_description.text = newString
             return cell
           
            }
            
        }
            
        }
       
    }
    
//    @objc func buttonClicked(sender: UIButton) {
//
//
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        StaticData.singleton.isEditCart = "NO"
       
        if(tableView == sugessionTable){
            
          self.searchbar.text = menuArray[indexPath.row] as? String
            self.sugessionView.alpha = 0

            filteredArray(searchString: (menuArray[indexPath.row] as? String)!)
        }else{
            if(self.open == "0"){
                
            }else{
        if(searchActive == true){
            
            let obj:Itemlist = self.filtered[indexPath.section].listOfProducts[indexPath.row]
            
            if(obj.orderStatus1 == "0"){
                appDelegate.showActivityIndicatory(uiView:self.view)
                KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
                let isValid:Bool = self.isInternetAvailable()
                
                if(isValid){
                    
                    childRef1.observeSingleEvent(of:.value, with: { (snapshot) in
                        
                        
                        
                        if snapshot.childrenCount > 0 {
                            self.childRef1.removeValue()
                            let obj:Itemlist = self.filtered[indexPath.section].listOfProducts[indexPath.row]
                            print(obj.name1!)
                            StaticData.singleton.menu_item = obj.name1
                            StaticData.singleton.menu_Description = obj.description1
                            StaticData.singleton.menu_price = obj.price1
                            StaticData.singleton.MenuItemID = obj.id1
                            
                            self.performSegue(withIdentifier:"addcart", sender: nil)
                        }else{
                            
                            let obj:Itemlist = self.filtered[indexPath.section].listOfProducts[indexPath.row]
                            print(obj.name1!)
                            StaticData.singleton.menu_item = obj.name1
                            StaticData.singleton.menu_Description = obj.description1
                            StaticData.singleton.menu_price = obj.price1
                            StaticData.singleton.MenuItemID = obj.id1
                            
                            self.performSegue(withIdentifier:"addcart", sender: nil)
                        }
                    })
                }else{
                    self.alertModule(title:"Error", msg:"The Internet connection appears to be offline.")
                }
            }else{
                
                
            }
           
        }else{
            if(indexPath.section == 0){
                
            }else{
                
                let obj:Itemlist = self.notificaionArray[indexPath.section].listOfProducts[indexPath.row]
                if(obj.orderStatus1 == "0"){
                appDelegate.showActivityIndicatory(uiView:self.view)
                KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
                let isValid:Bool = self.isInternetAvailable()
                
                if(isValid){
                    
                   childRef1.observeSingleEvent(of:.value, with: { (snapshot) in
                        
                        
                        
                        if snapshot.childrenCount > 0 {
                            self.childRef1.removeValue()
                            let obj:Itemlist = self.notificaionArray[indexPath.section].listOfProducts[indexPath.row]
                            print(obj.name1!)
                            StaticData.singleton.menu_item = obj.name1
                            StaticData.singleton.menu_Description = obj.description1
                            StaticData.singleton.menu_price = obj.price1
                            StaticData.singleton.MenuItemID = obj.id1
                            
                            self.performSegue(withIdentifier:"addcart", sender: nil)
                        }else{
                            
                            let obj:Itemlist = self.notificaionArray[indexPath.section].listOfProducts[indexPath.row]
                            print(obj.name1!)
                            StaticData.singleton.menu_item = obj.name1
                            StaticData.singleton.menu_Description = obj.description1
                            StaticData.singleton.menu_price = obj.price1
                            StaticData.singleton.MenuItemID = obj.id1
                            
                            self.performSegue(withIdentifier:"addcart", sender: nil)
                            
                        }
                    })
                }else{
                    self.view.isUserInteractionEnabled = true
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                    self.alertModule(title:"Error", msg:"The Internet connection appears to be offline.")
                }
                    
                }else{
                    
                }
            }
        }
            
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        self.sugessionView.alpha = 0
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
    
    func filteredArray(searchString:String){
        // we will use NSPredicate to find the string in array
        print(searchString)
        self.filtered.removeAll()
        if((self.notificaionArray.count) > 0){
            for i in 0...(notificaionArray.count)-1{
                let obj:Menu = notificaionArray[i]
                if obj.name!.range(of:searchString) != nil {
                    self.filtered.append(obj)
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
    
    @IBAction func cross(_ sender: Any) {
        
        close_btn.alpha = 0
        close_image.alpha = 0
        searchbar.text = ""
        searchActive = false
        tableview.reloadData()
        self.sugessionView.alpha = 0
        searchbar.resignFirstResponder()
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
    
    @IBAction func about(_ sender: Any) {
        
        
        // Prepare the popup assets
        let title = StaticData.singleton.Rest_name
        let message = StaticData.singleton.Rest_About
        //let image = UIImage(named: "Unknown")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image:nil)
        
        // Create buttons
        let buttonOne = CancelButton(title: "Close") {
            print("You canceled the car dialog.")
        }
        
        //        // This button will not the dismiss the dialog
        //        let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
        //            print("What a beauty!")
        //        }
        //
        //        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
        //            print("Ah, maybe next time :)")
        //        }
        
        // Add buttons to dialog
        // Alternatively, you can use popup.addButton(buttonOne)
        // to add a single button
        popup.addButtons([buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    
    
 
   

}
