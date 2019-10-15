//
//  3rdTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/23/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class _rdTableViewCell: UITableViewCell {
    
    @IBOutlet var addcard: UIButton!
    
    @IBOutlet var cash_payment: UIButton!
    
    @IBOutlet var paypal: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
