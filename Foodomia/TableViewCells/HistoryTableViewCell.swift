//
//  HistoryTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var htitle: UILabel!
    
    @IBOutlet weak var hdescription: UILabel!
    
    @IBOutlet weak var rPrice: UILabel!
    
    @IBOutlet weak var hResidence: UILabel!
    
    @IBOutlet weak var htrack: UILabel!
    
    @IBOutlet weak var hprice: UILabel!
    
    @IBOutlet weak var himg: UIImageView!
    
    @IBOutlet weak var btn_track: UIButton!
    @IBOutlet weak var hdate: UILabel!
    
    @IBOutlet weak var horderNO: UILabel!
    
    @IBOutlet weak var htime: UILabel!
    
    @IBOutlet weak var img_deal: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
