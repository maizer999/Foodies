//
//  CardDetailTableViewCell.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/25/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class CardDetailTableViewCell: UITableViewCell {
    

    @IBOutlet weak var cartPrice: UILabel!
    
    @IBOutlet var subname: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
