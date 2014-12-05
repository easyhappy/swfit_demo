//
//  Restaurant.swift
//  NewFoodPin
//
//  Created by andyhu on 14/12/2.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//
import Foundation
import CoreData
import UIKit

class Restaurant: NSManagedObject{
    @NSManaged var name:String!
    @NSManaged var type:String!
    @NSManaged var location:String!
    @NSManaged var image:NSData
    @NSManaged var isVisited:NSNumber!
    
//    init(name:String, type:String, location:String, image:String, isVisited:Bool) {
//        
//        self.name = name
//        self.type = type
//        self.location = location
//        self.image =  UIImage(named: image)
//        self.isVisited = isVisited
//    }
}