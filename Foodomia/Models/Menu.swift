//
//  Menu.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/18/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import Foundation

struct Itemlist {
    
    var id1:String! = ""
    var name1:String! = ""
    var description1:String! = ""
    var price1:String! = ""
    var orderStatus1:String! = ""
}
class Menu: NSObject {
    
    var id:String! = ""
    var name:String! = ""
    var mydescription:String! = ""
     var listOfProducts = [Itemlist]()
  

}
