//
//  ScaryBugData.swift
//  MacAppDev01
//
//  Created by ist on 2018/10/17.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa

class ScaryBugData: NSObject {

    /// bug的名称
    var title: String = ""
    /// bug的重要程度
    var rating: Float
    
    init(title: String, rating: Float) {
        self.title = title
        self.rating = rating
    }
}
