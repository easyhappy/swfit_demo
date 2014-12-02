//
//  Restaurant.swift
//  NewFoodPin
//
//  Created by andyhu on 14/12/2.
//  Copyright (c) 2014年 andyhu. All rights reserved.
//


class Restaurant{
    var name:String = ""
    var type:String = ""
    var location:String = ""
    var image:String = ""
    var isVisited:Bool = false
    
    init(name:String, type:String, location:String, image:String, isVisited:Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isVisited = isVisited
    }
}