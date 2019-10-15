//
//  AddScheduleViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/7/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import DatePickerDialog
import Alamofire
import SwiftyJSON
import KRProgressHUD
import FSCalendar

class AddScheduleViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var btn_end: UIButton!
    @IBOutlet weak var btn_start: UIButton!
    
    var start:String! = ""
    var end:String! = ""
    
    var DateArray:NSMutableArray = []
    
    
    @IBOutlet weak var title_txt: UILabel!
    
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var switchbar: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        calendarView.dataSource = self
        calendarView.delegate = self
   
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        //self.title = StaticData.singleton.days!
        
        let myString:String = StaticData.singleton.timeing!
        if(myString == ""){
            calendarView.isUserInteractionEnabled = true
            title_txt.text = "Add Availbility"
        }else{
            calendarView.isUserInteractionEnabled = false
            title_txt.text = "Edit Availbility"
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            let date2 = dateFormatter2.date(from:StaticData.singleton.days!)
            calendarView.select(date2)
            self.DateArray.add(StaticData.singleton.days!)
        var myStringArr = myString.components(separatedBy:"-")
       btn_start.setTitle(myStringArr[0], for: .normal)
        let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "hh:mm a"
            let date = dateFormatter1.date(from:myStringArr[0])
            dateFormatter1.dateFormat = "HH:mm"
            self.start = dateFormatter1.string(from:date!)
        btn_end.setTitle(myStringArr[1], for: .normal)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            let date1 = dateFormatter.date(from:myStringArr[1])
            dateFormatter.dateFormat = "HH:mm"
            self.end = dateFormatter.string(from:date1!)
    }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      
       
        let inputFormatter = DateFormatter()
      
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = inputFormatter.string(from: date)
            
            if(DateArray.contains(resultString)){
                
            }else{
                
                DateArray.add(resultString)
            }
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
      
     
        let inputFormatter = DateFormatter()
        
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = inputFormatter.string(from: date)
            if(DateArray.contains(resultString)){
                
                DateArray.remove(resultString)
            }else{
                
                
            }
        }
        
    
    
   
    
    
    func TimingsApi(){
   
        
        appDelegate.showActivityIndicatory(uiView:self.view)
        
        KRProgressHUD.show()

DispatchQueue.main.asyncAfter(deadline: .now()+1) {
   KRProgressHUD.dismiss()
}
        let string = DateArray.map { String(describing: $0) }
            .joined(separator: ", ")
        let url : String = appDelegate.baseUrl+appDelegate.addRiderTiming
        let headers: HTTPHeaders = [
            "api-key": "2a5588cf-4cf3-4f1c-9548-cc1db4b54ae3"
            
        ]
        var parameter :[String:Any]?
        if(StaticData.singleton.isTimeID == "yes"){
            parameter = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"starting_time":self.start,"ending_time":self.end,"date":string,"id":StaticData.singleton.timeID!]
    }else{
            parameter = ["user_id":UserDefaults.standard.string(forKey: "uid")!,"starting_time":self.start,"ending_time":self.end,"date":string]
    
    }
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
                  
                   self.dismiss(animated:true, completion:nil)
                    
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
  
    
    
    @IBAction func switchAction(_ sender: Any) {
        
        if(switchbar.isOn){
            
            innerView.isHidden = false
            btn_start.setTitle("11:59 AM", for: .normal)
            btn_end.setTitle("12:00 PM", for: .normal)
            self.start = "11:59:00"
            self.end = "23:59:00"
           
        }else{
            btn_start.setTitle("Start", for: .normal)
            btn_end.setTitle("End", for: .normal)
            innerView.isHidden = true
        }
        
        
    }
    
    @IBAction func StartAction(_ sender: Any) {
        
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode:.time) {
            (backDate) -> Void in
            if let dt = backDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                self.btn_start.setTitle(dateFormatter.string(from:dt), for: .normal)
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "HH:mm"
                self.start = dateFormatter1.string(from:dt)
          
                
            }
        }
        
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    @IBAction func EndAction(_ sender: Any) {
        
        if(self.start == "" || self.start == nil){
            self.alertModule(title:"Error", msg:"Please enter start time first.")
        }else{
        
        DatePickerDialog().show("TimePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode:.time) {
            (backDate) -> Void in
            if let dt = backDate{
                let dateFormatter = DateFormatter()
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "HH:mm"
                
                
                self.end = dateFormatter1.string(from:dt)
                let time2 = dateFormatter1.date(from:self.end)
                let time1 = dateFormatter1.date(from:self.start)
                let difference = Calendar.current.dateComponents([.hour], from: time1!, to: time2!)
                var formattedString = String(format: "%02ld", difference.hour!)
                var absou:Int! = 02
                dateFormatter.dateFormat = "hh:mm a"
                if(formattedString.contains("-")){
                    //let name: String = formattedString
                    formattedString = String(formattedString.characters.dropFirst())
                    absou = Int(formattedString)
                    
                }else{
                    absou = Int(formattedString)
                    print(formattedString)
                }
              
                
                print(absou)
                if(absou < 2){
                
                    self.alertModule(title:"Error", msg:"Minimum shift should be 2 hours.")
                }else{
                    
                    self.btn_end.setTitle(dateFormatter.string(from:dt), for: .normal)
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
     
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func save(_ sender: Any) {
        
       
        
        if(btn_start.titleLabel?.text == "Start"){
            
            self.alertModule(title:"Error", msg: "Please enter start time.")
            
        }else if(btn_end.titleLabel?.text == "End"){
            
            self.alertModule(title:"Error", msg: "Please enter end time.")
        }else if(self.DateArray.count <= 0){
            
            self.alertModule(title:"Error", msg: "Please select atleast one date.")
        }
        else{
            
            self.TimingsApi()
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated:true, completion:nil)
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
