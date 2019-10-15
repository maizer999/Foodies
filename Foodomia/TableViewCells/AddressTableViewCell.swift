//
//  AddressTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/28/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var myAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
