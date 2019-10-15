//
//  riderTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/31/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class riderTableViewCell: UITableViewCell {
    
 
    @IBOutlet weak var rider_order: UILabel!
    
    @IBOutlet weak var hotel_name: UILabel!
    
    
    @IBOutlet weak var rider_price: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
