//
//  CardDetail2TableCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class CardDetail2TableCell: UITableViewCell {
    
    @IBOutlet weak var subtotal: UILabel!
    
    
    @IBOutlet weak var tip_field: UITextField!
    
    @IBOutlet weak var btn_tip: UIButton!
    
    @IBOutlet weak var btn_pick: UIButton!
    
    @IBOutlet weak var btn_delivery: UIButton!
    
    @IBOutlet weak var tax: UILabel!
    
    @IBOutlet weak var fee: UILabel!
    
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var btn_payment: UIButton!
    
    @IBOutlet weak var btn_address: UIButton!
    
    @IBOutlet weak var txt_promo: UITextField!
    
     @IBOutlet weak var btn_send: UIButton!
    
    @IBOutlet weak var txt_payment: UITextField!
    
    @IBOutlet weak var txt_address: UITextField!
    
    @IBOutlet weak var tex_label: UILabel!
    
    
    @IBOutlet weak var txt_tip: UILabel!
    
    @IBOutlet weak var discount_txt: UILabel!
    
    @IBOutlet weak var discount_applied: UILabel!
    
    @IBOutlet weak var discount_per: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
