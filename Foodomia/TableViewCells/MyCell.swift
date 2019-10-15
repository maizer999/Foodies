//
//  MyCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 4/14/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var orderNo: UILabel!
    
    @IBOutlet weak var deal_img: UIImageView!
    
    @IBOutlet weak var order_status: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
