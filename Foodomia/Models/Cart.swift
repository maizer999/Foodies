//
//  Cart.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/9/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import Foundation

struct cartlist {
    
    var name1:String! = ""
    var quantity1:String! = ""
    var price1:String! = ""
   
}

class Cart: NSObject {
    var id1:String! = ""
    var key1:String! = ""
    var price:String! = ""
    var name:String! = ""
    var myquantity:String! = ""
     var myFee:String! = ""
      var myTax:String! = ""
    var myRestID:String! = ""
    var myDesc:String! = ""
    var Minprice:String! = ""
    
     var myCurrency:String! = ""
    var listOfcarts = [cartlist]()
    

}
