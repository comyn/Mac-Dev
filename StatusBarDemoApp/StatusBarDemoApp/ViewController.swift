//
//  ViewController.swift
//  StatusBarDemoApp
//
//  Created by ist on 2018/10/19.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    /// 添加状态栏item属性
    
    var demoItem: NSStatusItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.demoItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let image = NSImage(named: "settings")
        self.demoItem.button?.image = image
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

