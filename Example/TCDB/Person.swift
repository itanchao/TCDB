//
//  Person.swift
//  TCDB_Example
//
//  Created by 谈超 on 2017/6/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//
struct Person {
    var id : String
    var name : String?
    var sex : Bool?
    var phone : String?
    init(dic:[String:Any]) {
        id    = "\(dic["id"]!)"
        name  = dic["name"] as? String
        sex   = "\(dic["sex"]!)" == "1"
        phone = dic["phone"] as? String
    }
    
    
    
    
}
