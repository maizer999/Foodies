//
//  Mulk.swift
//  Foodomia
//
//  Created by Rao Mudassar on 12/18/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class Mulk: NSObject {
    
    var CountryName:String! = nil
    var CountryCode:String! = nil
    var CountryImg:String! = nil
    
    
    init(CountryName: String!, CountryCode: String!,CountryImg:String!) {
        
        self.CountryName = CountryName
        self.CountryCode = CountryCode
        self.CountryImg = CountryImg
        
        
    }
}
