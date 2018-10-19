//
//  AppDelegate.swift
//  StatusBarDemoApp
//
//  Created by ist on 2018/10/19.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// 添加状态栏item属性
    var demoItem: NSStatusItem!
    /// 弹窗
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        
        creatStatuBarItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

extension AppDelegate {
    func creatStatuBarItem() {
        // 创建NSStatusItem并添加到系统状态栏上
        self.demoItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // 设置NSStatusItem的图片
        let image = NSImage(named: "settings")
        self.demoItem.button?.image = image
        
        // 创建popover
        self.popover = NSPopover()
        self.popover.behavior = NSPopover.Behavior.transient
        self.popover.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
        let sbPopoVC = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SBPopoVC") as! SBPopoViewController
        self.popover.contentViewController = sbPopoVC
        // 为NSStatusItem添加点击事件
        self.demoItem.target = self
        self.demoItem.button?.action = #selector(showMyPopover(button:))
        
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.leftMouseDown) { [weak self] (event) in
            if self!.popover.isShown {
                self!.popover.close()
            }
        }
    }
    
    @objc func showMyPopover(button: NSStatusBarButton) {
        self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
    }
}

