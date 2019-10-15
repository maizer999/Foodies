//
//  RiderTiming.swift
//  Foodomia
//
//  Created by Rao Mudassar on 11/7/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit

class RiderTiming: NSObject {
    
    
    var Timeid:String! = ""
    var user_id:String! = ""
    var dateString:String! = ""
    var starting_time:String! = ""
    var ending_time:String! = ""
    var Confirm:String! = ""
    var admin_confirm:String! = ""
    
    
    
    init(Timeid: String!, user_id: String!,dateString:String!,starting_time: String!,ending_time:String!,Confirm:String!,admin_confirm:String!) {
      
        self.Timeid = Timeid
        self.user_id = user_id
        self.dateString = dateString
        self.ending_time = ending_time
        self.Confirm = Confirm
        self.starting_time = starting_time
        self.admin_confirm = admin_confirm
        
    }
  
}

