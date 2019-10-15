//
//  Constants.swift
//  ChatDemo
//
//  Created by Abu Turab on 06/07/2017.
//  Copyright © 2017 NARSUN-MAC-01. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
struct Constants
{
    struct refs
    {
        static let databaseRoot = FIRDatabase.database().reference()
        static let databaseChats = databaseRoot.child("Chat")
    }
}
