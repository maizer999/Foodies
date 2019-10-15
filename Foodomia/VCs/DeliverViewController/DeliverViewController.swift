//
//  DeliverViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/1/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class DeliverViewController: UIViewController {
    
    @IBOutlet weak var collect_instruction: UILabel!
    
    @IBOutlet weak var order_number: UILabel!
    
    @IBOutlet weak var rider_name: UILabel!
    
    @IBOutlet weak var rider_phone: UILabel!
    
    @IBOutlet weak var rider_address: UILabel!
    
    @IBOutlet weak var order_price: UILabel!
    
    @IBOutlet weak var payment_type: UILabel!
    
    
    var dDict:Riderorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        order_number.text = "Order# "+dDict.orderid
        rider_phone.text = dDict.phone
        rider_name.text =  dDict.first_name+" "+dDict.last_name
        order_price.text = "$ "+dDict.price
        rider_address.text = dDict.address
        collect_instruction.text  = dDict.User_Instruction
        if(dDict.cod == "1"){
        payment_type.text = "Cash On Delivery"
        }else{
            
            payment_type.text = "Credit Card"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Direction(_ sender: Any) {
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps:")!) {
            var urlString = "comgooglemaps://?ll=\((dDict?.Rest_latitute! as! NSString).doubleValue),\((dDict.Rest_longitude! as! NSString).doubleValue)&daddr=\((dDict?.latitude! as! NSString).doubleValue),\((dDict?.longitude as! NSString).doubleValue)"
            print(urlString)
            UIApplication.shared.openURL(URL(string: urlString)!)
        }
        else {
            var string = "http://maps.google.com/maps//?ll=\((dDict?.Rest_latitute! as! NSString).doubleValue),\((dDict.Rest_longitude! as! NSString).doubleValue)&daddr=\((dDict?.latitude! as! NSString).doubleValue),\((dDict?.longitude as! NSString).doubleValue)"
            UIApplication.shared.openURL(URL(string: string)!)
        }
        
    }
    
    @IBAction func phoneCall(_ sender: Any) {
        
        if let phoneCallURL = URL(string: "tel://"+dDict.phone) {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
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
