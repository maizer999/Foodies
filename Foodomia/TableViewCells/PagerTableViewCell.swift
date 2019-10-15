//
//  PagerTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/10/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import ImageSlideshow

class PagerTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var slidesImage: ImageSlideshow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
