
//
//  ScaryBugsDoc.swift
//  MacAppDev01
//
//  Created by ist on 2018/10/17.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa

class ScaryBugsDoc: NSObject {
    var data: ScaryBugData
    /// 缩略图
    var thumbImage: NSImage?
    /// 全尺寸图
    var fullImage: NSImage?
    init(title: String, rating: Float, thumbImage: NSImage?, fullImage: NSImage?) {
        self.data = ScaryBugData(title: title, rating: rating)
        self.thumbImage = thumbImage
        self.fullImage = fullImage
    }
}
