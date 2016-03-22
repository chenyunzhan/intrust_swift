//
//  CellModel.swift
//  intrust
//
//  Created by zhan on 16/3/17.
//  Copyright © 2016年 cloud. All rights reserved.
//

import Foundation


class CellModel{
    var image: String
    var desc: String?
    var sign1: String?
    var sign2: String?
    var title: String
    
    
    init(fromDictionary dictionary: NSDictionary, cellDic: NSDictionary) {
        
        if let image = dictionary[cellDic["image"] as! String] as? String {
            self.image = image
        } else {
            self.image = ""
        }
        if let title = dictionary[cellDic["title"] as! String] as? String {
            self.title = title
        } else {
            self.title = ""
        }
//        if let sign2 = dictionary[cellDic["sign2"] as! String] as? String {
//            self.sign2 = sign2
//        } else {
//            self.sign2 = ""
//        }
//        if let sign1 = dictionary[cellDic["sign1"] as! String] as? String {
//            self.sign1 = sign1
//        } else {
//            self.sign1 = ""
//        }
//        if let desc = dictionary[cellDic["desc"] as! String] as? String {
//            self.desc = desc
//        } else {
//            self.desc = ""
//        }

    }
}