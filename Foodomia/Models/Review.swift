//
//  Review.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/19/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class Review: NSObject {
    
    var id:String! = nil
    var comment:String! = nil
    var reviewname:String! = nil
     var reviewRating:String! = nil
     var reviewTime:String! = nil
    
    init(id: String!, comment: String!,reviewname:String!,reviewRating:String!,reviewTime:String!) {
        
        self.id = id
        self.comment = comment
        self.reviewname = reviewname
        self.reviewRating = reviewRating
        self.reviewTime = reviewTime
        
    }

}
