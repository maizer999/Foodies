//
//  CardDetail.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/13/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class CardDetail: NSObject {
    
    var cardID:String! = nil
    
    var brand:String! = nil
    var last4:String! = nil
    var name:String! = nil
    
    init(brand: String!, last4: String!, name:String!,cardID:String!) {
        
        self.brand = brand
        self.last4 = last4
        self.name = name
        self.cardID = cardID
      
        
        
    }

}
