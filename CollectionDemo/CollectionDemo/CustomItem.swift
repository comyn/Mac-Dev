//
//  CustomItem.swift
//  CollectionDemo
//
//  Created by ist on 2018/10/19.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa

class CustomItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        self.imageView?.image = NSImage(named: "ladybug")
    }
    
}
