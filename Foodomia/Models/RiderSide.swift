//
//  RiderSide.swift
//  Foodomia
//
//  Created by Rao Mudassar on 4/30/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit

class RiderSide: NSObject {
    
    var order_id:String! = ""
    var hotel_name:String! = ""
    var order_price:String! = ""
    var key:String! = ""
    var symbol:String! = ""
    var status:String! = ""

    
    
    init(order_id: String!, hotel_name: String!,order_price:String!,key:String!,symbol:String!,status:String!) {
        
        self.order_id = order_id
        self.hotel_name = hotel_name
        self.order_price = order_price
        self.key = key
        self.symbol = symbol
        self.status = status
        
        
    }
}
