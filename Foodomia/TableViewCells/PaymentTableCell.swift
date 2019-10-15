//
//  PaymentTableCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/27/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class PaymentTableCell: UITableViewCell {

    @IBOutlet var check_btn: UIImageView!
    
    @IBOutlet var card_img: UIImageView!
    
    @IBOutlet var card_number: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
