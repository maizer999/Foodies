//
//  Restuarant.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/17/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class Restuarant: NSObject {
    
    var about:String! = nil
    var delivery_fee:String! = nil
    var image:String! = nil
    var id:String! = nil
    var menu_style:String! = nil
    var name:String! = nil
    var phone:String! = nil
    var slogan:String! = nil
    var totalRating:String! = nil
    var avgRating:String! = nil
    var isFav:String! = nil
    var distance:String! = nil
    var cover_image:String! = nil
    var currency:String! = nil
    var tax:String! = nil
    var promote:String! = nil
    var preTime:String! = nil
    var min_order_price:String! = nil
    var delivery_fee_per_km:String! = nil
    var ResAddress:String! = ""
    var delivery_free_range:String! = ""
    var est_delivery:String! = ""
    
    init(about: String!, delivery_fee: String!, image:String! , id:String! , menu_style:String! , name:String! , phone:String! , slogan:String!, totalRating:String!, avgRating:String!,isFav:String!,distance:String!,cover_image:String!,currency:String!,tax:String!,promote:String!,preTime:String!,min_order_price:String!,delivery_fee_per_km:String!,delivery_free_range:String!,ResAddress:String!,est_delivery:String!) {
        
        self.about = about
        self.delivery_fee = delivery_fee
        self.image = image
        self.id = id
        self.menu_style = menu_style
        self.name = name
        self.phone = phone
        self.slogan = slogan
        self.totalRating = totalRating
        self.avgRating = avgRating
        self.isFav = isFav
        self.distance = distance
        self.cover_image = cover_image
        self.currency = currency
        self.tax = tax
        self.promote = promote
        self.preTime = preTime
        self.min_order_price = min_order_price
        self.delivery_fee_per_km = delivery_fee_per_km
        self.ResAddress = ResAddress
        self.delivery_free_range = delivery_free_range
        self.est_delivery = est_delivery
        
        
    }
}
