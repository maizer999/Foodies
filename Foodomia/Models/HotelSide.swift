//
//  HotelSide.swift
//  Foodomia
//
//  Created by Rao Mudassar on 4/14/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit

class HotelSide: NSObject {

    var order_id:String! = ""
    var order_status:String! = ""
    var order_deal:String! = ""
    var key:String! = ""
    var type:String! = ""
    
    
    init(order_id: String!, order_status: String!,order_deal:String!,key:String!,type:String!) {
        
        self.order_id = order_id
        self.order_status = order_status
        self.order_deal = order_deal
        self.key = key
        self.type = type
        
        
    }
}
