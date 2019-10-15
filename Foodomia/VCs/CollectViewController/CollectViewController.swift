//
//  CollectViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/1/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class CollectViewController: UIViewController {
    
    @IBOutlet weak var collect_instruction: UILabel!
    
    @IBOutlet weak var order_number: UILabel!
    
    @IBOutlet weak var rider_name: UILabel!
    
    @IBOutlet weak var rider_phone: UILabel!
    
    @IBOutlet weak var rider_address: UILabel!
    
    @IBOutlet weak var order_price: UILabel!
    
    var cDict:Riderorder!
   
    @IBOutlet weak var payment_type: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        order_number.text = "Order# "+cDict.orderid
        rider_phone.text = cDict.rest_phone
        rider_name.text = cDict.rest_name
        order_price.text = "$ "+cDict.price
     rider_address.text = cDict.Rest_address
        if(cDict.cod == "1"){
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
    
    @IBAction func phoneCall(_ sender: Any) {
        
        if let phoneCallURL = URL(string: "tel://"+cDict.rest_phone) {
            
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
