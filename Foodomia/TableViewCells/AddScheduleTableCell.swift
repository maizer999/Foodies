//
//  AddScheduleTableCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 3/6/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit

class AddScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var txt_datename: UILabel!
    
    @IBOutlet weak var txt_timename: UILabel!
    
    @IBOutlet weak var btn_confirm: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
