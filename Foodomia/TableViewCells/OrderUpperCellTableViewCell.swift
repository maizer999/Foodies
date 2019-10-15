//
//  OrderUpperCellTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/15/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import Cosmos

class OrderUpperCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btn_about: UIButton!
    @IBOutlet weak var btn_reviews: UIButton!
    
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var salogan: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var de_fee: UILabel!
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var rating_view: CosmosView!
    @IBOutlet weak var logo_image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
