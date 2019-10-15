//
//  TodayJobCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 5/1/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit

class TodayJobCell: UITableViewCell {
    @IBOutlet weak var rider_order: UILabel!
    
    @IBOutlet weak var hotel_name: UILabel!
    
    
    @IBOutlet weak var rider_price: UILabel!
    @IBOutlet weak var rider_name: UILabel!
    
    @IBOutlet weak var rider_payment: UILabel!
    
    
    @IBOutlet weak var rider_time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
