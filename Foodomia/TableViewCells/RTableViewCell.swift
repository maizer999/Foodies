//
//  RTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/25/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Cosmos

class RTableViewCell: UITableViewCell {
    
    @IBOutlet var rating_view: CosmosView!
    
    @IBOutlet var R_img: UIImageView!
    
    @IBOutlet var R_title: UILabel!
    
    @IBOutlet var R_description: UILabel!
    
    @IBOutlet weak var txt_minorder: UILabel!
    @IBOutlet var R_price: UILabel!
    
    @IBOutlet var R_distance: UILabel!
    
    @IBOutlet weak var pre_time: UILabel!
    @IBOutlet var R_time: UILabel!
    
    @IBOutlet weak var txt_estFee: UILabel!
   
    
    @IBOutlet var rating_count: UILabel!
    @IBOutlet weak var heart_img: UIImageView!
    @IBOutlet weak var btn_favourite: UIButton!
    
    @IBOutlet weak var feature_img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
