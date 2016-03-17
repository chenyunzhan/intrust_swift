//
//  CommandModel.swift
//  intrust
//
//  Created by zhan on 16/3/16.
//  Copyright © 2016年 cloud. All rights reserved.
//

import Foundation


class CommandModel: NSObject{
    var icon: String
    var id: String
    var title: String
    var url: String
    
    
    init(fromDictionary dictionary: NSDictionary) {
        
        self.icon = dictionary["icon"] as! String
        self.id = dictionary["id"] as! String
        self.title = dictionary["title"] as! String
        
        if let url = dictionary["url"] as? String {
            self.url = url
        } else {
            self.url = "";
        }
    }
}