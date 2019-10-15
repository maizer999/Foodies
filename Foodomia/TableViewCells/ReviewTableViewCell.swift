//
//  ReviewTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/26/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet var review_time: UILabel!
    
    @IBOutlet var review_image: UIImageView!
    
    @IBOutlet var review_name: UILabel!
    
    @IBOutlet var review_description: UILabel!
    
    @IBOutlet weak var rRatings: CosmosView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
