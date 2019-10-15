//
//  MenuItem.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/18/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class MenuItem: NSObject {

    
    var id1:String! = nil
    var name1:String! = nil
    var description1:String! = nil
     var price1:String! = nil
    
    init(id1: String!, name1: String!, description1:String!,price1:String) {
        
        self.id1 = id1
        self.name1 = name1
        self.description1 = description1
        self.price1 = price1
        
        
    }
}
