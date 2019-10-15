//
//  OrderTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/25/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet var order_name: UILabel!
    
    @IBOutlet var order_description: UILabel!
    
    @IBOutlet var order_price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
