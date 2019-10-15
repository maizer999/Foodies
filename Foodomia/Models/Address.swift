//
//  Address.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/17/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class Address: NSObject {
    
    var apartment:String! = nil
    var city:String! = nil
   var country:String! = nil
   var id:String! = nil
   var instruction:String! = nil
   var state:String! = nil
   var street:String! = nil
   var zip:String! = nil
    var delivery_fee:String! = nil
    var total_amount:String! = nil
    
    init(apartment: String!, city: String!, country:String! , id:String! , instruction:String! , state:String! , street:String! , zip:String!,delivery_fee:String!,total_amount:String!) {
        
        self.apartment = apartment
        self.city = city
        self.country = country
        self.id = id
        self.instruction = instruction
        self.state = state
        self.street = street
        self.zip = zip
        self.delivery_fee = delivery_fee
        self.total_amount = total_amount
        
        
        
    }

}
