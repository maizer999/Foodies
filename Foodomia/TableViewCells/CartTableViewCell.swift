//
//  CartTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/24/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet var box_img: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
