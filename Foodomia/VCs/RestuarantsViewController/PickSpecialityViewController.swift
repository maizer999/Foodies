//
//  PickSpecialityViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 1/6/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD
import Alamofire
import SwiftyJSON
import SDWebImage

class PickSpecialityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var searchbar: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var myView: UIView!
    @IBOutlet var tableView: UITableView!
    
    
    var filtered:NSMutableArray = []
    var Array:NSMutableArray = []
    
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.PickAllCountry()
        
        
        //self.PickAllCountry()
        //self.PickSendCountry()
        //self.PickReceiveCountry()
        
        
        
    }
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    func PickAllCountry(){
        
        Array = []
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        
        let url : String = appDelegate.baseUrl+appDelegate.showRestaurantsSpecialities
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        Alamofire.request(url, method: .post, parameters:nil, encoding: URLEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                let json  = value
                
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    let my = dic["msg"] as? [[String:Any]]
                    for Dict in my! {
                        let myAddress = Dict["Restaurant"] as! [String:String]
                        
                        let speciality = myAddress["speciality"]
                        
                        
                        self.Array.add(speciality)
                    }
                    
                    print(self.Array.count)
                    if(self.Array.count == 0){
                        
                        //                                            self.alertModule(title:"Error", msg:"NO Address Detail Found.")
                    }else{
                        
                        self.tableView.reloadData()
                    }
                    
                }else{
                    
                    
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive == true){
            return filtered.count
        }else{
            return Array.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier:"pick", for: indexPath) as! CountryTableViewCell
        
        if(searchActive == true){
           
            cell.country_name.text = filtered[indexPath.row] as? String
           
            
            
        }else{
            cell.country_name.text = Array[indexPath.row] as? String
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(searchActive == true){
           
            UserDefaults.standard.set(filtered[indexPath.row] as? String, forKey:"Speciality")
            StaticData.singleton.isSpecitialy = "yes"
           
            
            
        }else{
           
            UserDefaults.standard.set(Array[indexPath.row] as? String, forKey:"Speciality")
            StaticData.singleton.isSpecitialy = "yes"
           
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
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
        if((self.Array.count) > 0){
            for i in 0...(Array.count)-1{
                let obj:String! = Array[i] as? String
                if obj.lowercased().range(of:searchString) != nil {
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
        self.tableView.reloadData()
        
    }

}
