//
//  Riderorder.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/31/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class Riderorder: NSObject {
    
    var orderid:String! = nil
    var created:String! = nil
    var price:String! = nil
    var last_name:String! = nil
    var phone:String! = nil
    var user_id:String! = nil
    var address:String! = nil
    var first_name:String! = nil
    var rest_name:String! = nil
    var rest_salogan:String! = nil
    var rest_phone:String! = nil
    var latitude:String! = nil
    var longitude:String! = nil
    var Rest_address:String! = nil
    var Rest_latitute:String! = nil
    var Rest_longitude:String! = nil
    var User_Instruction:String! = nil
    var cod:String! = nil
    var symbol:String! = ""
     var fee:String! = nil
    var per:String! = nil
    var sub_total:String! = nil
    var colltime:String! = nil
    var deltime:String! = nil
    var riderTip:String! = nil
    var riderIns:String! = ""
    var taxFree:String! = "0.0"
    var taxValue:String! = "0.0"
    
    init(orderid: String!, created: String!, price:String!,last_name: String!,first_name: String!, phone: String!, user_id:String!,address: String!,rest_name: String!, rest_salogan: String!,rest_phone:String!,latitude:String!,longitude:String!,Rest_address:String!,Rest_latitute:String!,Rest_longitude:String!,User_Instruction:String!,cod:String!,symbol:String!,fee:String!,per:String!,sub_total:String!,colltime:String!,deltime:String!,riderTip:String!,riderIns:String!,taxFree:String!,taxValue:String!) {
        
        self.orderid = orderid
        self.created = created
        self.price = price
        self.last_name = last_name
        self.first_name = first_name
        self.phone = phone
        self.user_id = user_id
        self.address = address
        self.rest_name = rest_name
        self.rest_salogan = rest_salogan
        self.rest_phone = rest_phone
        self.latitude = latitude
        self.longitude = longitude
        self.Rest_address = Rest_address
        self.Rest_latitute = Rest_latitute
        self.Rest_longitude = Rest_longitude
        self.User_Instruction = User_Instruction
        self.cod = cod
        self.symbol = symbol
        self.fee = fee
        self.per = per
        self.sub_total = sub_total
        self.colltime = colltime
        self.deltime = deltime
        self.riderTip = riderTip
         self.riderIns = riderIns
        self.taxFree = taxFree
        self.taxValue = taxValue
        
        
        
    }

}
