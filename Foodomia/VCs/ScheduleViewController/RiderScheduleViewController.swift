//
//  RiderScheduleViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/6/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON
import KRProgressHUD
import DatePickerDialog

class RiderScheduleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var index:IndexPath!
    var start:String! = ""
    var end:String! = ""
    var open_shift_id:String! = ""
  
    var loadingToggle:String? = "yes"
    var refreshControl = UIRefreshControl()

    var dayToggle:String! = ""
    var Mon:NSMutableArray = []
    
   
    @IBOutlet weak var mySegment: UISegmentedControl!
    var section:Int! = 0
  
     let appDelegate = UIApplication.shared.delegate as! AppDelegate


    
    var sectionArray:NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(RestuarntsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)
     
       self.tableView.backgroundColor = UIColor.init(red:235/255.0, green:235/255.0, blue:235/255.0, alpha: 1.0)
      
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        
        dayToggle = "mon"
        StaticData.singleton.timeing = ""
        StaticData.singleton.days = "monday"
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd-MM-yyyy"
        let result = formatter.string(from: date)
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let result1 = formatter1.string(from: date)
         StaticData.singleton.days = result1
        //txt_today.text = result
        dayToggle = result
       
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StaticData.singleton.timeing = ""
        StaticData.singleton.isTimeID = "no"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd-MM-yyyy"
        let result = formatter.string(from: date)
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd"
        let result1 = formatter1.string(from: date)
        StaticData.singleton.days = result1
        //txt_today.text = result
        dayToggle = result
      
        self.TimingsApi()
    }

    @objc func refresh(sender:AnyObject) {
        loadingToggle = "no"
        self.TimingsApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentMethod(_ sender: Any) {
        let seg:Int! = (sender as AnyObject).selectedSegmentIndex
        if seg == 0 {
          self.TimingsApi()
        }else{
           self.TimingsApi()
        }
        
    }
    
    func TimingsApi(){
        
       
     
        if(loadingToggle == "yes"){
            
            appDelegate.showActivityIndicatory(uiView:self.view)
            KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        }
      
        let url : String = appDelegate.baseUrl+appDelegate.showRiderTimingBasedOnDate
        
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"date":StaticData.singleton.days!]
                print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                self.Mon = []
                self.sectionArray = []
                let json  = value
                self.view.isUserInteractionEnabled = true
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    let myCountry = dic["msg"] as? NSDictionary
                    if(self.mySegment.selectedSegmentIndex == 1){
                    let myRiderTiming1 = myCountry?["OpenShift"] as? NSArray
                    if myRiderTiming1?.count == 0{
                        
                    }else{
                    for i in 0...(myRiderTiming1?.count)!-1{
                        let riderDate = myRiderTiming1![i] as! NSDictionary
                       
                        //                        let inputFormatter = DateFormatter()
                        //                        inputFormatter.dateFormat = "yyyy-MM-dd"
                        //                        let showDate = inputFormatter.date(from:riderDate["date"] as! String)
                        //                        inputFormatter.dateFormat = "  "
                        //                        let day2 = inputFormatter.string(from:showDate!)
                       
                        let singleTiming = riderDate["timing"] as! NSArray
                        for j in 0...singleTiming.count-1{
                            let myDict = singleTiming[j] as! NSDictionary
                            let Timeid = myDict["id"] as? String
                            let user_id = "-1"
                            let dateString = myDict["date"] as! String
                            let admin_confirm = ""
                            let Confirm = "0"
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm:ss"
                            let date = dateFormatter.date(from:myDict["starting_time"]! as! String)
                            dateFormatter.dateFormat = "hh:mm a"
                           let starting_time = dateFormatter.string(from:date!)
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "HH:mm:ss"
                            let date1 = dateFormatter1.date(from:myDict["ending_time"]! as! String)
                            dateFormatter1.dateFormat = "hh:mm a"
                           let ending_time = dateFormatter.string(from:date1!)
                            let obj = RiderTiming(Timeid:Timeid as! String, user_id:user_id,dateString:dateString as! String,starting_time:starting_time as! String,ending_time:ending_time as! String,Confirm:Confirm,admin_confirm: admin_confirm as! String)
                            
                            self.Mon.add(obj)
                            
                        }
                        
                       
                        
                        
                    }
                    }
                    }else{
                   
                    let myRiderTiming = myCountry?["RiderTiming"] as? NSArray
                    
                    if myRiderTiming?.count == 0{
                        
                    }else{
                    for i in 0...(myRiderTiming?.count)!-1{
                        let riderDate = myRiderTiming![i] as! NSDictionary
                        
                        
                        let singleTiming = riderDate["timing"] as! NSArray
                        for j in 0...singleTiming.count-1{
                            let myDict = singleTiming[j] as! NSDictionary
                            let Timeid = myDict["id"] as? String
                            let user_id = myDict["user_id"] as? String
                            let dateString = myDict["date"] as! String
                            let admin_confirm = myDict["admin_confirm"] as! String
                            
                            let Confirm = myDict["confirm"] as? String
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm:ss"
                            let date = dateFormatter.date(from:myDict["starting_time"]! as! String)
                            dateFormatter.dateFormat = "hh:mm a"
                            let starting_time = dateFormatter.string(from:date!)
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "HH:mm:ss"
                            let date1 = dateFormatter1.date(from:myDict["ending_time"]! as! String)
                            dateFormatter1.dateFormat = "hh:mm a"
                            let ending_time = dateFormatter.string(from:date1!)
                            let obj = RiderTiming(Timeid:Timeid as! String, user_id:user_id as! String,dateString:dateString as! String,starting_time:starting_time as! String,ending_time:ending_time as! String,Confirm:Confirm as! String,admin_confirm: admin_confirm as! String)
                            
                           self.Mon.add(obj)
                       
                        
                        }
                       
                       
                    
                    }
                
                
                    }
                    }
                self.refreshControl.endRefreshing()
                if(self.Mon.count == 0){
                  
                 
                   
                    self.tableView.reloadData()
                }else{
                  
                    
                    self.tableView.reloadData()
                }
                    
                  
                    
                }else{
                    
                    //self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                self.refreshControl.endRefreshing()
                KRProgressHUD.dismiss {
                    print("dismiss() completion handler.")
                }
                print(error)
                self.alertModule(title:"Error", msg:error.localizedDescription)
                
                
            }
        })
        
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//
//
//            return self.Mon.count
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
    
            return self.Mon.count
        
     
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 79
        
    }

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(mySegment.selectedSegmentIndex == 0){
            
            let cell:AddScheduleTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "146th") as! AddScheduleTableViewCell
            
            let obj = Mon[indexPath.row] as! RiderTiming
        
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from:obj.dateString)
            inputFormatter.dateFormat = "MMMM EEEE dd,yyyy"
            let day2 = inputFormatter.string(from:showDate!)
            
            cell.txt_datename.text = day2
            
            cell.txt_timename.text = (obj.starting_time)!+"-"+(obj.ending_time)!
            if(obj.admin_confirm == "1"){
               
                
            if(obj.Confirm == "1"){
                
                cell.btn_confirm.setTitle("Confirmed", for:.normal)
                cell.btn_confirm.backgroundColor = UIColor.clear
                cell.btn_confirm.setTitleColor(UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0), for:.normal)
                
            }else{
                cell.btn_confirm.setTitle("Confirm", for:.normal)
                cell.btn_confirm.tag = indexPath.row
                
                cell.btn_confirm.addTarget(self, action: #selector(RiderScheduleViewController.pressPlay1(_:)), for: .touchUpInside)
                cell.btn_confirm.backgroundColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
                cell.btn_confirm.setTitleColor(UIColor.white, for:.normal)
               //cell.btn_confirm.alpha = 1
                
            }
            }else{
                cell.btn_confirm.setTitle("In Review", for:.normal)
                cell.btn_confirm.backgroundColor = UIColor.clear
                cell.btn_confirm.setTitleColor(UIColor.init(red:71/255.0, green:71/255.0, blue:71/255.0, alpha: 1.0), for:.normal)
            }
            
            
            return cell
            
            
        }else{
            let cell:ScheduleTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "46th") as! ScheduleTableViewCell
            
            let obj = Mon[indexPath.row] as! RiderTiming
            
            
            //StaticData.singleton.timeing = (obj?.starting_time)!+"-"+(obj?.ending_time)!
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let showDate = inputFormatter.date(from:obj.dateString)
            inputFormatter.dateFormat = "MMMM EEEE dd,yyyy"
            let day2 = inputFormatter.string(from:showDate!)
            
            cell.date_lbl.text = day2
            
            cell.name_lbl.text = (obj.starting_time)!+"-"+(obj.ending_time)!
            
            
                    cell.btn_add.tag = indexPath.row
            
                     cell.btn_add.addTarget(self, action: #selector(RiderScheduleViewController.pressPlay2(_:)), for: .touchUpInside)
            return cell
            
        }
       

    }
    
    @objc func pressPlay1(_ sender: UIButton){

        let buttonrow:Int! = sender.tag
        print(buttonrow)
         print(section)
       let obj = Mon[buttonrow] as! RiderTiming

            //appDelegate.showActivityIndicatory(uiView:self.view)

            //KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
            let url : String = appDelegate.baseUrl+appDelegate.updateRiderShiftStatus

            let parameter :[String:Any]? = ["id":obj.Timeid,"confirm":"1"]
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]

            print(parameter!)

            Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {

                respones in

                switch respones.result {
                case .success( let value):

                    let json  = value
                    //self.view.isUserInteractionEnabled = true

                    print(json)
                    let dic = json as! NSDictionary
                    let code = dic["code"] as! NSNumber
                    if(String(describing: code) == "200"){

                        self.TimingsApi()



                    }else{

                        //self.alertModule(title:"Error", msg:dic["msg"] as! String)


                    }



                case .failure(let error):
                    self.view.isUserInteractionEnabled = true
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                    print(error)
                    self.alertModule(title:"Error", msg:error.localizedDescription)


                }
            })
        

    }
    
    @objc func pressPlay2(_ sender: UIButton){
        
        let buttonrow:Int! = sender.tag
        print(buttonrow)
        print(section)
        let obj = Mon[buttonrow] as! RiderTiming
        StaticData.singleton.timeID = obj.Timeid
        StaticData.singleton.days = obj.dateString
        self.start = obj.starting_time
        self.end = obj.ending_time
        self.open_shift_id = obj.Timeid
        
        self.DeleteModule1()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }
    
   
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(mySegment.selectedSegmentIndex == 0){
            
            return true
        }else{
            
           return false
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                let obj = self.Mon[indexPath.row] as! RiderTiming
                StaticData.singleton.timeID = obj.Timeid
                StaticData.singleton.days = obj.dateString
                //self.Mon.remove(at:indexPath.row)
                self.DeleteTimingsApi()
            }
            
            let Edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                
                let obj = self.Mon[indexPath.row] as! RiderTiming
                
                StaticData.singleton.days = obj.dateString
                StaticData.singleton.isTimeID = "yes"
                StaticData.singleton.timeID = obj.Timeid
                StaticData.singleton.timeing = (obj.starting_time)!+"-"+(obj.ending_time)!
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddScheduleViewController
                
                self.present(secondVC, animated: true, completion: nil)
            }
            
            Edit.backgroundColor = UIColor.init(red:221/255.0, green:221/255.0, blue:221/255.0, alpha: 1.0)
            //Edit.textlabel.textcolor = UIColor.redColor()
            
            return [delete, Edit]
        
}
    
    func DeleteModule1(){
        
        
        let alertController = UIAlertController(title:"Warning!", message:"Are you sure you want to Add?", preferredStyle: .alert)
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        let alertAction2 = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {(alert : UIAlertAction!) in
   
            let url : String = self.appDelegate.baseUrl+self.appDelegate.addRiderTiming
            
            let headers: HTTPHeaders = [
                "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
                
            ]
            
            let parameter = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"starting_time":self.start,"ending_time":self.end,"date":StaticData.singleton.days,"open_shift_id":self.open_shift_id]
            
            print(parameter)
            
            Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
                
                respones in
                
                switch respones.result {
                case .success( let value):
                    
                    let json  = value
                    //self.view.isUserInteractionEnabled = true
                    
                    print(json)
                    let dic = json as! NSDictionary
                    let code = dic["code"] as! NSNumber
                    if(String(describing: code) == "200"){
                        
                        self.TimingsApi()
                        
                        
                        
                    }else{
                        
                        self.alertModule(title:"Error", msg:dic["msg"] as! String)
                        
                        
                    }
                    
                    
                    
                case .failure(let error):
                    self.view.isUserInteractionEnabled = true
                    KRProgressHUD.dismiss {
                        print("dismiss() completion handler.")
                    }
                    print(error)
                    self.alertModule(title:"Error", msg:error.localizedDescription)
                    
                    
                }
            })
            
        })
        
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
      
        present(alertController, animated: true, completion: nil)
        
    }

    
    func DeleteTimingsApi(){
 
        appDelegate.showActivityIndicatory(uiView:self.view)
        
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let url : String = appDelegate.baseUrl+appDelegate.deleteRiderTiming
        
        let parameter :[String:Any]? = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"date":StaticData.singleton.days!,"id":StaticData.singleton.timeID!]
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        print(parameter!)
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding:JSONEncoding.default, headers:headers).validate().responseJSON(completionHandler: {
            
            respones in
            
            switch respones.result {
            case .success( let value):
                
                let json  = value
                self.view.isUserInteractionEnabled = true
               
                print(json)
                let dic = json as! NSDictionary
                let code = dic["code"] as! NSNumber
                if(String(describing: code) == "200"){
                    
                    //self.tableView.deleteRows(at: [self.index], with: .fade)
                    //self.tableView.reloadData()
                   
                    StaticData.singleton.timeing = ""
                    StaticData.singleton.timeID = ""
                    let date = Date()
                    let formatter1 = DateFormatter()
                    formatter1.dateFormat = "yyyy-MM-dd"
                    let result1 = formatter1.string(from: date)
                    StaticData.singleton.days = result1
                    self.TimingsApi()
                     //self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                
                }else{
                    
                    self.alertModule(title:"Error", msg:dic["msg"] as! String)
                    
                    
                }
                
                
                
            case .failure(let error):
                self.view.isUserInteractionEnabled = true
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
      
        self.present(alertController, animated: true, completion: nil)
        
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
