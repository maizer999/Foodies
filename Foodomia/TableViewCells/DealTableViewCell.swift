//
//  DealTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/6/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class DealTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dTitle: UILabel!
    
    @IBOutlet weak var dTime: UILabel!
    @IBOutlet weak var dDescrp: UILabel!
    
    @IBOutlet weak var d_img: UIImageView!
    @IBOutlet weak var dPrice: UILabel!
    @IBOutlet weak var feature_img: UIImageView!
    
    @IBOutlet weak var txt_MinOrder: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
