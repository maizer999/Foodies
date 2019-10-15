//
//  RestaurantDetailDealViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/20/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantDetailDealViewController: UIViewController {
    @IBOutlet weak var detail_img: UIImageView!
    
    @IBOutlet weak var stail_title: UILabel!
    
    @IBOutlet weak var detail_price: UILabel!
    
    @IBOutlet weak var detail_rest: UILabel!
    
    @IBOutlet weak var detail_des: UITextView!
    
    @IBOutlet weak var deal_cart: UIView!
    
    @IBOutlet weak var cart_txt: UILabel!
    
    var count:Int! = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        detail_img.sd_setImage(with: URL(string:StaticData.singleton.detailimg!), placeholderImage: UIImage(named: "Unknown"))
        
        stail_title.text = StaticData.singleton.detailTitle!
        detail_price.text = StaticData.singleton.dealSymbol!+StaticData.singleton.detailprice!
        detail_rest.text = StaticData.singleton.detailrest!
        detail_des.text = StaticData.singleton.detaildes!
        
        StaticData.singleton.RestDealQuantity = String(count)
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        StaticData.singleton.AccountID = ""
        StaticData.singleton.AddressID = ""
        StaticData.singleton.cardnumber = ""
        StaticData.singleton.cardAddress = ""
        StaticData.singleton.cart_addressFee = ""
        StaticData.singleton.cart_addresstotal = "";
        self.title = StaticData.singleton.detailTitle!
    }
    
    @IBAction func close(_ sender: Any) {
        StaticData.singleton.RestDealQuantity = "1"
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func minus(_ sender: Any) {
        if(count == 1){
            
        }else{
        count = count-1
        cart_txt.text = String(count)
        StaticData.singleton.RestDealQuantity = String(count)
    }
    }
    
    @IBAction func plus(_ sender: Any) {
        count = count+1
        cart_txt.text = String(count)
        StaticData.singleton.RestDealQuantity = String(count)
    }
    
    
    
  

}
