//
//  ScheduleTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/6/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name_lbl: UILabel!

    @IBOutlet weak var date_lbl: UILabel!
    
    @IBOutlet weak var btn_add: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
