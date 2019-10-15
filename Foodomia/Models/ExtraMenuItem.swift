//
//  ExtraMenuItem.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/18/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class ExtraMenuItem: NSObject {

    var id2:String! = nil
    var name2:String! = nil
    var description2:String! = nil
    var price2:String! = nil
    
    init(id2: String!, name2: String!, description2:String!,price2:String) {
        
        self.id2 = id2
        self.name2 = name2
        self.description2 = description2
        self.price2 = price2
        
        
    }
}
