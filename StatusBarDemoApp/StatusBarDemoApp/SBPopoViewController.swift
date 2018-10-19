//
//  SBPopoViewController.swift
//  StatusBarDemoApp
//
//  Created by ist on 2018/10/19.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa

class SBPopoViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}
