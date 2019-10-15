//
//  AddCartViewController.swift
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
import Firebase
import FirebaseDatabase
import Foundation
import SystemConfiguration


class AddCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
     let childRef = FIRDatabase.database().reference().child("Cart").child(UserDefaults.standard.string(forKey:"udid")!).childByAutoId();
    var childRef1 = FIRDatabase.database().reference().child("Calculation").child(UserDefaults.standard.string(forKey:"udid")!).childByAutoId();
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var cart_view: UIView!
    
   var headerLabel = UILabel()
    var headerView = UIView()
    @IBOutlet var title1: UILabel!
    
    var count:Int? = 1
    var countParam:NSNumber = 0
    var selectedIndex:IndexPath?
    var selectedSection:Int? = -1
    var extraunitprice:Float! = 0.0
    var totalPrice:Float! = 0.0
    var quan:Float! = 0.0
   
    var togglebool:String! = "No"
     var count1:Int? = 0
    var count2:NSNumber = 0
    @IBOutlet var name: UILabel!
    
    @IBOutlet var price: UILabel!
    
    @IBOutlet var desc: UILabel!
    
    @IBOutlet var tableview: UITableView!
    
     var ItemList = [Sectionlist]()
    var ItemListradio:NSMutableArray = []
    var SectionList:NSMutableArray = []
    @IBOutlet weak var btn_cart: UIButton!
    
    @IBOutlet var cart_Value: UILabel!
    var para:NSMutableDictionary = NSMutableDictionary()
    var prodArray:NSMutableArray = NSMutableArray()
     var prodArray1:NSMutableArray = NSMutableArray()
    let para1:NSMutableDictionary = NSMutableDictionary()
    var checkIsRadioSelect = [Int]()
    
    @IBOutlet var total_value: UILabel!
    
    var food_value:Int = 0
    var extra_itemValue:Int = 0
    var notificaionArray = [Cart]()
    var key1:String?
    var key2:String?
    
    var textStr:String! = ""
    
    var myPara:NSArray!
    var selectedRows = [String:NSIndexPath]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
      self.tableview.alwaysBounceVertical = false
    
       title1.text = StaticData.singleton.menu_item
        name.text = StaticData.singleton.menu_item
        let newString = StaticData.singleton.menu_Description?.replacingOccurrences(of: "&amp;", with: "&", options: .literal, range: nil)
        StaticData.singleton.menu_Description = newString
        desc.text = StaticData.singleton.menu_Description
        price.text = StaticData.singleton.currSymbol!+StaticData.singleton.menu_price!
        //total_value.text = "$"+StaticData.singleton.menu_price!
        
     self.getExtraMenuesItem()
        
        key1 = self.childRef1.childByAutoId().key
         key2 = String(UInt64(arc4random()))
       
        
        self.childRef1.setValue(["key":key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":count1,"ExtraItem":self.prodArray])
        
        self.LoadCalculationDetail()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(StaticData.singleton.isEditCart == "YES"){
            
            btn_cart.setTitle("Update Cart", for: .normal)
        }else{
            
            btn_cart.setTitle("Add to Cart", for: .normal)
        }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getExtraMenuesItem(){
        
        ItemList = []

        appDelegate.showActivityIndicatory(uiView:self.view)
        self.view.isUserInteractionEnabled = false
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        btn_cart.isUserInteractionEnabled = false
        
        let url : String = appDelegate.baseUrl+appDelegate.showMenuExtraItems
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["restaurant_menu_item_id":StaticData.singleton.MenuItemID!,"restaurant_id":StaticData.singleton.Rest_id]
        print(url)
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                self.count2 = dic["count"] as! NSNumber
                print(self.count2)
                if(String(describing: code) == "200"){
                    
                    let myCountry = dic["msg"] as? [[String:Any]]
                     for Dict in myCountry! {
                        let myRestaurant = Dict["RestaurantMenuExtraSection"] as! NSDictionary
                    if(myRestaurant == nil || myRestaurant.count == 0){}else{
                        
                             let tempObj = Sectionlist()
                            //let dic1 = myRestaurant[i] as! [String:Any]
                            tempObj.name = myRestaurant["name"] as? String
                            tempObj.req1 = myRestaurant["required"] as? String
                        
                            let RestaurantMenuItem = myRestaurant["RestaurantMenuExtraItem"] as! NSArray
                        if(RestaurantMenuItem == nil || RestaurantMenuItem.count == 0){}else{
                            for j in 0...RestaurantMenuItem.count-1{
                                var tempProductList = ExtraMenuList()
                                 let dic2 = RestaurantMenuItem[j] as! [String:Any]
                                tempProductList.id1 = dic2["id"] as? String
                                tempProductList.name1 = dic2["name"] as? String
                                tempProductList.description1  = "abc"
                                tempProductList.price1  = dic2["price"] as? String
                                tempProductList.req = myRestaurant["required"] as? String
                                tempObj.listOfExtras.append(tempProductList)
                                }
                            }
                         self.ItemList.append(tempObj)
                        }
             
                    }
                    self.view.isUserInteractionEnabled = true
                    self.btn_cart.isUserInteractionEnabled = true
                    if(self.ItemList.count == 0){
                    
                    
                               // self.alertModule(title:"Error", msg:"NO Extra Item Found.")
                               // self.firstsection.isHidden = true
                            }else{
                    
                                self.tableview.reloadData()
                                //self.firstsection.isHidden = false
                            }
                    
                }else{
                    
                    
                    self.alertModule(title:"Error",msg:dic["msg"] as! String)
                    
                }
                
                
                
            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                //self.btn_cart.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                
                print(error)
                self.alertModule(title:"Error",msg:error.localizedDescription)
                
                
            }
        })
    }
    
   
    
    @IBAction func close(_ sender: Any) {
       
        
        self.childRef1.removeValue()
       
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func add(_ sender: Any) {
    self.prodArray1 = []
        count! = count!+1
        
        self.cart_Value.text = String(count!)
        if(self.prodArray.count > 0){
        for i in 0...self.prodArray.count-1{
            
            let dic1 = self.prodArray[i] as! [String:Any]
            
            let prod: NSMutableDictionary = NSMutableDictionary()
            
          prod.setValue(dic1["menu_extra_item_id"] as! String , forKey: "menu_extra_item_id")
            prod.setValue(dic1["menu_extra_item_name"] as! String, forKey: "menu_extra_item_name")
            prod.setValue(dic1["menu_extra_item_price"] as! String, forKey: "menu_extra_item_price")
            prod.setValue(self.cart_Value.text!, forKey: "menu_extra_item_quantity")
            
            self.prodArray1.add(prod)
               self.childRef1.setValue(["key":key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":count1,"ExtraItem":self.prodArray])
            }
        self.LoadCalculationDetail()
       
        }else{
            
           self.childRef1.setValue(["key":key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":count1,"ExtraItem":self.prodArray])
            
            self.LoadCalculationDetail()
        }
    }
    
    @IBAction func minus(_ sender: Any) {
       
        if(count as! Int >  1){
            count! = count!-1
            self.prodArray1 = []
             self.cart_Value.text = String(count!)
             if(self.prodArray.count > 0){
            for i in 0...self.prodArray.count-1{
                
                let dic1 = self.prodArray[i] as! [String:Any]
                let prod: NSMutableDictionary = NSMutableDictionary()
                prod.setValue(dic1["menu_extra_item_id"] as! String , forKey: "menu_extra_item_id")
                prod.setValue(dic1["menu_extra_item_name"] as! String, forKey: "menu_extra_item_name")
                prod.setValue(dic1["menu_extra_item_price"] as! String, forKey: "menu_extra_item_price")
                prod.setValue(self.cart_Value.text!, forKey: "menu_extra_item_quantity")
                self.prodArray1.add(prod)
                  self.childRef1.setValue(["key":key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":count1,"ExtraItem":self.prodArray])
                
            }
         
        }
        self.LoadCalculationDetail()
        }else{
            
              self.childRef1.setValue(["key":key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":count1,"ExtraItem":self.prodArray])
        
        self.LoadCalculationDetail()
        }
    }
    
    func addcart(){
        
        self.food_value = (count! * Int(StaticData.singleton.menu_price!)!)
        total_value.text = "$ "+String(self.food_value)
        
    }
    
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
   
        return ItemList.count+1
        
    }
    
    func addSelectedCellWithSection(indexPath:NSIndexPath) ->NSIndexPath?
    {
        let existingIndexPath = selectedRows["\(indexPath.section)"];
        if (existingIndexPath == nil) {
            selectedRows["\(indexPath.section)"]=indexPath;
        }else
        {
            selectedRows["\(indexPath.section)"]=indexPath;
            return existingIndexPath
        }
        
        return nil;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == ItemList.count){
            
            return 1
        }else{
            
          
            return ItemList[section].listOfExtras.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == ItemList.count){
            return 60
        }else{
            
            return 57
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.init(red:242/255.0, green:242/255.0, blue:242/255.0, alpha: 1.0)
        
        headerLabel = UILabel(frame: CGRect(x: 15, y:10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        headerLabel.font = UIFont.systemFont(ofSize:12, weight:UIFont.Weight.regular)
        headerLabel.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
        
        if section < ItemList.count {
      
            let obj = ItemList[section]
            
            if(obj.req1 == "1"){
                let str:String! = obj.name.uppercased()
                headerLabel.text = str+" (Required)"
                let range = NSRange(location:(headerLabel.text?.characters.count)!-11,length:11) // specific location. This means "range" handle 1 character at location 2
                
                let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: headerLabel.text!, attributes: [NSAttributedStringKey.font: UIFont (name: "Verdana", size:12)])
                // here you change the character to red color
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0), range: range)
                headerLabel.attributedText = attributedString
                
            }else{
            headerLabel.textColor = UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0)
                headerLabel.text = obj.name.uppercased()
                
            }
            
            
        }else{
            
            headerLabel.text = "Instruction".uppercased()

        }
        
        
//        headerLabel.text = self.tableView(self.tableview, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        
        return headerView
    }
    
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if(indexPath.section == ItemList.count){
            
            let cell:InsViewCell = tableview.dequeueReusableCell(withIdentifier: "5thCell") as! InsViewCell
            
            cell.ins_txt.delegate = self
            cell.ins_txt.text = "Special Instruction (Optional)"
            cell.ins_txt.textColor = UIColor.lightGray
            selectedIndex = indexPath

            return cell
    
            
         }else
         {
       
            let obj:ExtraMenuList
                = ItemList[indexPath.section].listOfExtras[indexPath.row]
           //let prod: NSMutableDictionary = NSMutableDictionary()
                
                let cell:Cart1TableViewCell = tableview.dequeueReusableCell(withIdentifier: "44thCell") as! Cart1TableViewCell
            if(obj.req == "1"){
                
                if(obj.isSelected == "Yes"){
                    
                   cell.cart_img.image = UIImage(named:"Button")!
                    cell.cart_name.text = obj.name1
                    cell.cart_price.text = "+"+StaticData.singleton.currSymbol!+obj.price1
                  
                    
                }else{
                    cell.cart_img.image = UIImage(named:"Circle")!
                    cell.cart_name.text = obj.name1
                    cell.cart_price.text = "+"+StaticData.singleton.currSymbol!+obj.price1
                   
                }
                
              
 
                return cell
            }else{
                let cell:CartTableViewCell = tableview.dequeueReusableCell(withIdentifier: "4thCell") as! CartTableViewCell
                if(obj.isSelected == "Yes"){
                    
                    cell.box_img.image = UIImage(named:"check")!
                    cell.name.text = obj.name1
                    cell.price.text = "+"+StaticData.singleton.currSymbol!+obj.price1
                    
                }else{
                    cell.box_img.image = UIImage(named:"Box")!
                    cell.name.text = obj.name1
                    cell.price.text = "+"+StaticData.singleton.currSymbol!+obj.price1
                }
                
                return cell
                
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     
        
        if(indexPath.section == ItemList.count){
            
            
        }else{
            self.view.isUserInteractionEnabled = false
            
            var obj:ExtraMenuList
                = ItemList[indexPath.section].listOfExtras[indexPath.row]
          
            
            if(obj.req == "1"){

                let prod: NSMutableDictionary = NSMutableDictionary()
                let cell = self.tableview.cellForRow(at: indexPath) as! Cart1TableViewCell
                if(cell.cart_img.image ==
                    UIImage(named: "Circle")){
                   
                    
                let previusSelectedCellIndexPath = self.addSelectedCellWithSection(indexPath: indexPath as NSIndexPath);
                
                if(previusSelectedCellIndexPath != nil)
                {
                   
                    let previusSelectedCell = self.tableview.cellForRow(at: previusSelectedCellIndexPath! as IndexPath) as! Cart1TableViewCell
                    var obj1:ExtraMenuList = ItemList[(previusSelectedCellIndexPath?.section)!].listOfExtras[(previusSelectedCellIndexPath?.row)!]
                    prod.setValue(obj1.id1, forKey: "menu_extra_item_id")
                    prod.setValue(obj1.name1, forKey: "menu_extra_item_name")
                    prod.setValue(obj1.price1, forKey: "menu_extra_item_price")
                    prod.setValue(cart_Value.text!, forKey: "menu_extra_item_quantity")
                    let val = FIRDatabase.database().reference().child("Calculation").child(UserDefaults.standard.string(forKey:"udid")!)
                    
                    
                    val.observeSingleEvent(of:.value, with: { (snapshot) in
                        self.notificaionArray = []
                        
                        if snapshot.childrenCount > 0 {
                            for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                                
                                let artistObject = artists.value as? [String: AnyObject]
                                print(artistObject!)
                                
                                if(artistObject?["ExtraItem"] != nil){
                                    self.myPara = []
                                    self.myPara = artistObject?["ExtraItem"] as! NSArray
                                    
                                    
                                    for i in 0...self.myPara.count-1{
                                        
                                        let dic1 = self.myPara[i] as! [String:Any]
                                        if(dic1["menu_extra_item_id"] as! String == obj1.id1){
                                            self.count1 = self.count1!-1
                                            self.prodArray.removeObject(at:i)
                                            previusSelectedCell.cart_img.image = UIImage(named:"Circle")!
                                            obj1.isSelected = ""
                                            self.ItemList[(previusSelectedCellIndexPath?.section)!].listOfExtras[(previusSelectedCellIndexPath?.row)!] = obj1
                                            
                                            self.childRef1.setValue(["key":self.key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":self.count1,"ExtraItem":self.prodArray])
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                    })
                    
                   
                    //
                   // self.LoadCalculationDetail()
                   
                    ItemList[(previusSelectedCellIndexPath?.section)!].listOfExtras[(previusSelectedCellIndexPath?.row)!] = obj
                    prod.setValue(obj.id1, forKey: "menu_extra_item_id")
                    prod.setValue(obj.name1, forKey: "menu_extra_item_name")
                    prod.setValue(obj.price1, forKey: "menu_extra_item_price")
                    prod.setValue(cart_Value.text!, forKey: "menu_extra_item_quantity")
                    prodArray.add(prod)
                    para1.setObject(prodArray, forKey:"ExtraMenuItem" as NSCopying)
                    
                    self.count1 = self.count1!+1
                  self.childRef1.setValue(["key":key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":count1,"ExtraItem":self.prodArray])
                    obj.isSelected = "Yes"
       
                    ItemList[indexPath.section].listOfExtras[indexPath.row] = obj
                    self.LoadCalculationDetail()
                  
                   cell.cart_img.image = UIImage(named:"Button")!
                    tableView.deselectRow(at: previusSelectedCellIndexPath! as IndexPath, animated: true);
                }
                else
                {
                    prod.setValue(obj.id1, forKey: "menu_extra_item_id")
                    prod.setValue(obj.name1, forKey: "menu_extra_item_name")
                    prod.setValue(obj.price1, forKey: "menu_extra_item_price")
                    prod.setValue(cart_Value.text!, forKey: "menu_extra_item_quantity")
                    prodArray.add(prod)
                    para1.setObject(prodArray, forKey:"ExtraMenuItem" as NSCopying)
                    
                    self.count1 = self.count1!+1
                    self.childRef1.setValue(["key":key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":count1,"ExtraItem":self.prodArray])
                    
                    self.LoadCalculationDetail()
                    obj.isSelected = "Yes"

                    ItemList[indexPath.section].listOfExtras[indexPath.row] = obj
                    cell.cart_img.image = UIImage(named:"Button")!
                }
                }else{
                    
                    self.view.isUserInteractionEnabled = true
                }
                
            }else{
               
            let currentCell:CartTableViewCell = tableView.cellForRow(at: indexPath) as! CartTableViewCell
            let prod: NSMutableDictionary = NSMutableDictionary()
            if(currentCell.box_img.image ==
                UIImage(named: "check")){
                
                obj.isSelected = ""
                ItemList[indexPath.section].listOfExtras[indexPath.row] = obj
                print(obj.isSelected)
                currentCell.box_img.image = UIImage(named:"Box")!
                
                //            self.extra_itemValue = self.extra_itemValue + (count! * Int(obj.price2)!)!
                print(obj.price1)
              
                prod.setValue(obj.id1, forKey: "menu_extra_item_id")
                prod.setValue(obj.name1, forKey: "menu_extra_item_name")
                prod.setValue(obj.price1, forKey: "menu_extra_item_price")
                prod.setValue(cart_Value.text!, forKey: "menu_extra_item_quantity")
                let val = FIRDatabase.database().reference().child("Calculation").child(UserDefaults.standard.string(forKey:"udid")!)
                
                
                val.observeSingleEvent(of:.value, with: { (snapshot) in
                    self.notificaionArray = []
                    
                    if snapshot.childrenCount > 0 {
                        for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                            
                            let artistObject = artists.value as? [String: AnyObject]
                            print(artistObject!)
                        
                            if(artistObject?["ExtraItem"] != nil){
                                self.myPara = []
                                self.myPara = artistObject?["ExtraItem"] as! NSArray
                                
                                
                                for i in 0...self.myPara.count-1{
                                    
                                    let dic1 = self.myPara[i] as! [String:Any]
                                    if(dic1["menu_extra_item_id"] as! String == obj.id1){
                                        self.prodArray.removeObject(at:i)
                                        self.childRef1.setValue(["key":self.self.key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":self.count1,"ExtraItem":self.prodArray])
                                    }
                                }
                            }
                            
                        }
                        
                    }
                        
                    })
                                    
          
                self.LoadCalculationDetail()
            
                
            }else{
                obj.isSelected = "Yes"
                ItemList[indexPath.section].listOfExtras[indexPath.row] = obj
                print(obj.price1)
                currentCell.box_img.image = UIImage(named:"check")!
                
                prod.setValue(obj.id1, forKey: "menu_extra_item_id")
                prod.setValue(obj.name1, forKey: "menu_extra_item_name")
                prod.setValue(obj.price1, forKey: "menu_extra_item_price")
                prod.setValue(cart_Value.text!, forKey: "menu_extra_item_quantity")
                prodArray.add(prod)
                para1.setObject(prodArray, forKey:"ExtraMenuItem" as NSCopying)
                
       
             self.childRef1.setValue(["key":key1!,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price as Any,"mquantity":self.cart_Value.text!,"required":count1,"ExtraItem":self.prodArray])
                
                self.LoadCalculationDetail()
                
                
                }
            
            }
  
        }
  
        
    
    }
    
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Special Instruction (Optional)"
            textView.textColor = UIColor.lightGray
        }else{
            
            textStr = textView.text
        }
    }
    
   
    @IBAction func addtocart(_ sender: Any) {
        if(StaticData.singleton.isEditCart == "YES"){
            let val = FIRDatabase.database().reference().child("Cart").child(UserDefaults.standard.string(forKey:"udid")!)
            val.observeSingleEvent(of:.value, with: { snapshot in
                
                if snapshot.childrenCount > 0 {
                    for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        
                        let artistObject = artists.value as? [String: AnyObject]
                        if(StaticData.singleton.CartKey == artistObject?["key"] as! String){
                            print(StaticData.singleton.CartKey!)
                            print(artists.key)
                            val.child(artists.key).removeValue()
                            self.normalAdd()
                        }else{
                            
                            
                        }
                    }
                }
                
            })
        }else{
            
            self.normalAdd()
        }
        
       
      
    }
    
    func normalAdd(){
        
        if(countParam == count2){
            
            //let indexPath = IndexPath(row: 0, section:ItemList.count)
            //let cell = self.tableview.cellForRow(at:selectedIndex!) as! InsViewCell
            if(textStr == "Special Instruction (Optional)"){
                
                textStr = ""
            }
            
            
            if(UserDefaults.standard.string(forKey:"Rest_id") == nil){
                UserDefaults.standard.set(StaticData.singleton.Rest_id, forKey: "Rest_id")
                para1.setValue(StaticData.singleton.menu_item, forKey:"mname")
                para1.setValue(StaticData.singleton.menu_price, forKey:"mprice")
                para1.setValue(cart_Value.text!, forKey:"mquantity")
                prodArray1.add(para1)
                para.setObject(prodArray1, forKey:"MenuItem" as NSCopying)
                StaticData.singleton.AccountID = ""
                StaticData.singleton.AddressID = ""
                StaticData.singleton.cardnumber = ""
                StaticData.singleton.cardAddress = ""
                StaticData.singleton.cart_addressFee = ""
                StaticData.singleton.cart_addresstotal = ""
                self.childRef.setValue(["key":key2!,"RestID":StaticData.singleton.Rest_id,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price,"mquantity":cart_Value.text!,"mCurrency":StaticData.singleton.currSymbol!
                    ,"Instruction":textStr,"mFee":"0","mTax":StaticData.singleton.restTax!,"ExtraItem":prodArray,"mMinPrice":StaticData.singleton.MinOrderprice!,"mDesc":StaticData.singleton.menu_Description])
                UserDefaults.standard.set(totalPrice, forKey:"totalPrice")
                //self.tabBarController?.tabBar.items?[3].badgeValue = "1"
                childRef1.removeValue()
                self.dismiss(animated:true, completion:nil)
                
                
            }else if(UserDefaults.standard.string(forKey:"Rest_id") == StaticData.singleton.Rest_id){
                if(UserDefaults.standard.value(forKey: "dict") == nil){
                    StaticData.singleton.AccountID = ""
                    StaticData.singleton.AddressID = ""
                    StaticData.singleton.cardnumber = ""
                    StaticData.singleton.cardAddress = ""
                    StaticData.singleton.cart_addressFee = ""
                    StaticData.singleton.cart_addresstotal = ""
                    
                    UserDefaults.standard.set(StaticData.singleton.Rest_id, forKey: "Rest_id")
                    para1.setValue(StaticData.singleton.menu_item, forKey:"mname")
                    para1.setValue(StaticData.singleton.menu_price, forKey:"mprice")
                    para1.setValue(cart_Value.text!, forKey:"mquantity")
                    prodArray1.add(para1)
                    para.setObject(prodArray1, forKey:"MenuItem" as NSCopying)
                    self.childRef.setValue(["key":key2!,"RestID":StaticData.singleton.Rest_id,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price,"mquantity":cart_Value.text!,"mCurrency":StaticData.singleton.currSymbol!,"Instruction":textStr,"mFee":"0","mTax":StaticData.singleton.restTax!,"ExtraItem":prodArray,"mMinPrice":StaticData.singleton.MinOrderprice!,"mDesc":StaticData.singleton.menu_Description])
                    UserDefaults.standard.set(totalPrice, forKey:"totalPrice")
                    //self.tabBarController?.tabBar.items?[3].badgeValue = "1"
                    childRef1.removeValue()
                    self.dismiss(animated:true, completion:nil)
                }else{
                    
                    StaticData.singleton.AccountID = ""
                    StaticData.singleton.AddressID = ""
                    StaticData.singleton.cardnumber = ""
                    StaticData.singleton.cardAddress = ""
                    StaticData.singleton.cart_addressFee = ""
                    StaticData.singleton.cart_addresstotal = ""
                    UserDefaults.standard.set(StaticData.singleton.Rest_id, forKey: "Rest_id")
                    self.para1.setValue(StaticData.singleton.menu_item, forKey:"mname")
                    self.para1.setValue(StaticData.singleton.menu_price, forKey:"mprice")
                    self.para1.setValue(self.cart_Value.text!, forKey:"mquantity")
                    self.prodArray1.add(self.para1)
                    self.para.setObject(self.prodArray1, forKey:"MenuItem" as NSCopying)
                    
                    self.childRef.setValue(["key":key2!,"RestID":StaticData.singleton.Rest_id,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price,"mquantity":cart_Value.text!,"mCurrency":StaticData.singleton.currSymbol!,"Instruction":textStr,"mFee":"0","mTax":StaticData.singleton.restTax!,"ExtraItem":prodArray,"mMinPrice":StaticData.singleton.MinOrderprice!,"mDesc":StaticData.singleton.menu_Description])
                    UserDefaults.standard.set(totalPrice, forKey:"totalPrice")
                    //self.tabBarController?.tabBar.items?[3].badgeValue = "1"
                    childRef1.removeValue()
                    self.dismiss(animated:true, completion:nil)
                }
                
            }else{
                self.alertModule1(title:"Changing Restaurants",msg:"Would you like to change your order from "+StaticData.singleton.Rest_name!+" and start a new order?")
                
            }
            
        }else{
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: tableview.center.x - 10, y: tableview.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: tableview.center.x + 10, y: tableview.center.y))
            
            tableview.layer.add(animation, forKey: "position")
                        self.alertModule(title:"Error", msg:"Please select atleast one from each required section.")
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
    func alertModule1(title:String,msg:String){
        //let indexPath = IndexPath(row: 0, section:ItemList.count)
        //let cell = tableview.cellForRow(at: indexPath) as! InsViewCell
        
        if(textStr == "Special Instruction (Optional)"){
            
            textStr = ""
        }
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        let alertAction2 = UIAlertAction(title: "Discard", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction!) in
           
            let val = FIRDatabase.database().reference().child("Cart").child(UserDefaults.standard.string(forKey:"udid")!)
            val.removeValue(completionBlock: { (error, refer) in
                if error != nil {
                    print(error)
                } else {
                    print(refer)
                    print("Child Removed Correctly")
                }
            })
             UserDefaults.standard.set(StaticData.singleton.Rest_id, forKey: "Rest_id")
            //self.tabBarController?.tabBar.items?[3].badgeValue = "1"
            StaticData.singleton.AccountID = ""
            StaticData.singleton.AddressID = ""
            StaticData.singleton.cardnumber = ""
            StaticData.singleton.cardAddress = ""
            StaticData.singleton.cart_addressFee = ""
            StaticData.singleton.cart_addresstotal = ""
            self.childRef.setValue(["key":self.key2!,"RestID":StaticData.singleton.Rest_id,"mID": StaticData.singleton.MenuItemID,"mname": StaticData.singleton.menu_item,"mprice":StaticData.singleton.menu_price,"mquantity":self.cart_Value.text!,"mCurrency":StaticData.singleton.currSymbol!,"Instruction":self.textStr,"mFee":"0","mTax":StaticData.singleton.restTax!,"ExtraItem":self.prodArray,"mMinPrice":StaticData.singleton.MinOrderprice!,"mDesc":StaticData.singleton.menu_Description])
            UserDefaults.standard.set(self.totalPrice, forKey:"totalPrice")
            
            self.childRef1.removeValue()
            self.dismiss(animated:true, completion:nil)
            
            
        })
        
      
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
      
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func LoadCalculationDetail(){
        
        let isValid:Bool = self.isInternetAvailable()
        
        if(isValid){
//            appDelegate.showActivityIndicatory(uiView:self.view)
//            KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
          
            let val = FIRDatabase.database().reference().child("Calculation").child(UserDefaults.standard.string(forKey:"udid")!)
           
            
            val.observe(FIRDataEventType.value, with: { (snapshot) in
                self.notificaionArray = []
               
                if snapshot.childrenCount > 0 {
                    self.tabBarController?.tabBar.items?[3].badgeValue = String(snapshot.childrenCount)
                    for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        
                        let artistObject = artists.value as? [String: AnyObject]
                        print(artistObject!)
                        
                        let tempMenuObj = Cart()
                       
                        tempMenuObj.name = artistObject?["mname"] as! String
                        tempMenuObj.price = artistObject?["mprice"] as! String
                        tempMenuObj.myquantity = artistObject?["mquantity"] as! String
                        self.totalPrice = Float(artistObject?["mprice"] as! String)
                        self.quan = Float(artistObject?["mquantity"] as! String)
                        self.totalPrice = self.totalPrice*self.quan
                        self.countParam = artistObject?["required"] as! NSNumber
                        if(artistObject?["ExtraItem"] != nil){
                            self.myPara = []
                            self.myPara = artistObject?["ExtraItem"] as! NSArray
                            
                            
                            for i in 0...self.myPara.count-1{
                                
                                var tempProductList = cartlist()
                                
                                
                                let dic1 = self.myPara[i] as! [String:Any]
                              
                                
                                
                                //self.extra![dic1]
                                //print(self.extra)
                                
                                tempProductList.name1 = dic1["menu_extra_item_name"] as! String
                                tempProductList.price1 = dic1["menu_extra_item_price"] as! String
                                tempProductList.quantity1 = dic1["menu_extra_item_quantity"] as! String
                                self.extraunitprice = Float(dic1["menu_extra_item_price"] as! String)
                                let myquantity:Float = self.quan*self.extraunitprice
                                print(myquantity)
                                self.totalPrice = self.totalPrice+myquantity
                                tempMenuObj.listOfcarts.append(tempProductList)
                                
                                
                                
                            }
                            
                            
                        }
                        
                        self.notificaionArray.append(tempMenuObj)
                    }
                    
                    
                    
                }
                self.view.isUserInteractionEnabled = true
                self.total_value.text = StaticData.singleton.currSymbol!+String(format: "%.2f",Float(self.totalPrice))
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                if(self.notificaionArray.count == 0){
                  
                }else{
                   
                   
                }
                
                
            })
            
        }else{
            
           
            self.alertModule(title:"Error", msg:"The Internet connection appears to be offline.")
            
        }
        
        
        
        
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
    
   

}
