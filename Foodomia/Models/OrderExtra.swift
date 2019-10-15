//
//  OrderExtra.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/19/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class OrderExtra: NSObject {
    
    var Extraid:String! = nil
    var Extraname:String! = nil
    var Extraquantity:String! = nil
    var Extraprice:String! = nil
    
    
    init(Extraid: String!, Extraname: String!, Extraquantity:String!,Extraprice: String!) {
        
        self.Extraid = Extraid
        self.Extraname = Extraname
        self.Extraquantity = Extraquantity
        self.Extraprice = Extraprice
        
        
        
        
    }

}
