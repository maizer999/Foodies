//
//  Deal.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/6/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class Deal: NSObject {

    var Dealid:String! = nil
    var restaurant_id:String! = nil
    var Dealname:String! = nil
    var Dealprice:String! = nil
    var expire_date:String! = nil
    var des_detail:String! = nil
    var cover_img:String! = nil
    var img:String! = nil
    var restaurant_name:String! = nil
    var Deal_curr:String! = nil
    var Deal_tax:String! = nil
     var Deal_fee:String! = nil
    var promote:String! = nil
    var min_order_price:String! = nil
    var delivery_fee_per_km:String! = nil
    
    
    init(Dealid: String!, restaurant_id: String!, Dealname:String!,Dealprice: String!,expire_date:String!,des_detail:String!,cover_img:String!,img:String!,restaurant_name:String!,Deal_curr:String!,Deal_tax:String!,Deal_fee:String!,promote:String!,min_order_price:String!,delivery_fee_per_km:String!) {
        
        self.Dealid = Dealid
        self.restaurant_id = restaurant_id
        self.Dealname = Dealname
        self.Dealprice = Dealprice
        self.expire_date = expire_date
        self.des_detail = des_detail
        self.cover_img = cover_img
        self.img = img
        self.restaurant_name = restaurant_name
        self.Deal_curr = Deal_curr
        self.Deal_tax = Deal_tax
        self.Deal_fee = Deal_fee
        self.promote = promote
        self.min_order_price = min_order_price
        self.delivery_fee_per_km = delivery_fee_per_km
   
    }
}
