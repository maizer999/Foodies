//
//  Order.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/19/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class Order: NSObject {
    
    var Menuid:String! = nil
    var Orderid:String! = nil
    var Menuname:String! = nil
    var Menuquantity:String! = nil
    var Menuprice:String! = nil
    var Created:String! = nil
    var Instruction:String! = nil
     var ExtraItemName:String! = nil
     var orderCurrency:String! = nil
    var RiderLat:String! = ""
    var RiderLon:String! = ""
    var RiderName:String! = ""
    var RiderPhone:String! = ""
    var hotel_accepted:String! = ""
    var deal_id:String! = ""
   
    
    init(Menuid: String!, Menuname: String!, Menuquantity:String!,Menuprice: String!,Orderid:String!,Created:String!,Instruction:String!,ExtraItemName:String!,orderCurrency:String!,RiderLat:String!,RiderLon:String!,RiderName:String!,RiderPhone:String!,hotel_accepted:String!,deal_id:String!) {
        
        self.Menuid = Menuid
        self.Menuname = Menuname
        self.Menuquantity = Menuquantity
        self.Menuprice = Menuprice
        self.Orderid = Orderid
        self.Created = Created
        self.Instruction = Instruction
        self.ExtraItemName = ExtraItemName
        self.orderCurrency = orderCurrency
        self.RiderLat = RiderLat
        self.RiderLon = RiderLon
        self.RiderName = RiderName
        self.RiderPhone = RiderPhone
        self.hotel_accepted = hotel_accepted
        self.deal_id = deal_id
        
        
        
        
    }

}
