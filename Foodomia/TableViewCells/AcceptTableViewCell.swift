//
//  AcceptTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/31/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class AcceptTableViewCell: UITableViewCell {
    
  
   
    
    @IBOutlet weak var btn_aacept: UIButton!
    
  
    
    @IBOutlet weak var acc_order: UILabel!
    
    @IBOutlet weak var acc_hotel: UILabel!
    
   
    
    @IBOutlet weak var acc_price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
