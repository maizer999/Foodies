//
//  TrackTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/22/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hortel_address: UILabel!
    
    @IBOutlet weak var hotel_phone: UILabel!
    
    @IBOutlet weak var txt_tip: UILabel!
    @IBOutlet weak var txt_tax: UILabel!
    
    @IBOutlet weak var user_name: UILabel!
  
    @IBOutlet weak var user_phone: UILabel!
    
    @IBOutlet weak var user_address: UILabel!
    @IBOutlet weak var txt_per: UILabel!
    @IBOutlet weak var hotel_name: UILabel!
    @IBOutlet weak var payment_name: UILabel!
    @IBOutlet weak var txt_fee: UILabel!
    
    @IBOutlet weak var mTotal_lbl: UILabel!
    @IBOutlet weak var subprice: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var btn_restAddress: UIButton!
    
    @IBOutlet weak var btnrestPhone: UIButton!
    
    @IBOutlet weak var btnuserphone: UIButton!
    
    @IBOutlet weak var btnuserAddress: UIButton!
    
    @IBOutlet weak var total_name: UILabel!
    
    @IBOutlet weak var txt_collection: UILabel!
    
    @IBOutlet weak var txt_delivery: UILabel!
    
    @IBOutlet weak var txt_payRest: UILabel!
    
    @IBOutlet weak var image_lbl: UIImageView!
    
    @IBOutlet weak var txt_instruction: UILabel!
    
    @IBOutlet weak var txt_Addins: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var mPay_lbl: UILabel!
    
    @IBOutlet weak var pay_view: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
