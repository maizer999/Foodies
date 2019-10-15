//
//  TrackConstant.swift
//  Foodomia
//
//  Created by Rao Mudassar on 3/21/18.
//  Copyright © 2018 dinosoftlabs. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct TrackConstant{
    struct refs
    {
        static let databaseRoot1 = FIRDatabase.database().reference()
        static let databasetrack = databaseRoot1.child("tracking")
    }
}
