//
//  Cart1TableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/2/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class Cart1TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cart_name: UILabel!
    
    @IBOutlet weak var cart_img: UIImageView!
    
    @IBOutlet weak var cart_price: UILabel!
    
    @IBOutlet weak var btn_add: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
