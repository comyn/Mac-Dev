//
//  ViewController.swift
//  MacAppDev01
//
//  Created by ist on 2018/10/17.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var bugTitleView: NSTextField!
    @IBOutlet weak var bugRating: EDStarRating!
    @IBOutlet weak var bugImageView: NSImageView!
    
    @IBOutlet weak var deleteButton: NSButton!
    
    @IBOutlet weak var changePictureButton: NSButton!
    var bugs = [ScaryBugsDoc]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let bug1 = ScaryBugsDoc(title: "Potato Bug", rating: 4, thumbImage: NSImage(named: "potatoBugThumb")!, fullImage: NSImage(named: "potatoBug")!)
        let bug2 = ScaryBugsDoc(title: "House Centipede", rating: 4, thumbImage: NSImage(named: "centipedeThumb")!, fullImage: NSImage(named: "centipede")!)
        let bug3 = ScaryBugsDoc(title: "Wolf Spider", rating: 4, thumbImage: NSImage(named: "wolfSpiderThumb")!, fullImage: NSImage(named: "wolfSpider")!)
        let bug4 = ScaryBugsDoc(title: "Lady Bug", rating: 4, thumbImage: NSImage(named: "ladybugThumb")!, fullImage: NSImage(named: "ladybug")!)
        bugs.append(bug1)
        bugs.append(bug2)
        bugs.append(bug3)
        bugs.append(bug4)
        
//        self.bugRating.starImage = NSImage(named: "star")
        self.bugRating.starHighlightedImage = NSImage(named: "shockedface2_full")
        self.bugRating.starImage = NSImage(named: "shockedface2_empty")
        self.bugRating.maxRating = 5.0
        self.bugRating.delegate = self
        self.bugRating.horizontalMargin = 12
        self.bugRating.editable = true
        self.bugRating.displayMode = EDStarRatingDisplay.full.rawValue
        self.bugRating.rating = 0.0
        self.bugRating.editable = false
    }

    /// 获取选中的数据类型
    func selectedBugDoc() -> ScaryBugsDoc? {
        let selectedRow = self.tableView.selectedRow
        if selectedRow >= 0 && self.bugs.count > selectedRow {
            return self.bugs[selectedRow]
        }
        return nil
    }
    
    func setDetailInfo(doc: ScaryBugsDoc?) {
        var title: String = "" // 初始化空字符串
        var image: NSImage? = nil // 初始化为控制
        var rating: Float = 0.0 // 初始化默认值为0
        if let doc = doc {
            title = doc.data.title
            image = doc.fullImage
            rating = doc.data.rating
        }
        self.bugTitleView.stringValue = title // 设置显示的标题
        self.bugImageView.image = image // 设置显示的图片
        self.bugRating.setRating(rating) // 设置评分
    }
    
    @IBAction func addBug(_ sender: Any) {
        let newDoc = ScaryBugsDoc(title: "New Bug", rating: 0.0, thumbImage: nil, fullImage: nil)
        self.bugs.append(newDoc)
        let newRowIndex = self.bugs.count - 1
        self.tableView.insertRows(at: IndexSet(integer: newRowIndex), withAnimation: NSTableView.AnimationOptions.effectGap)
        self.tableView.selectRowIndexes(IndexSet(integer: newRowIndex), byExtendingSelection: false)
        self.tableView.scrollRowToVisible(newRowIndex)
    }
    
    @IBAction func deleteBug(_ sender: Any) {
        guard let selectedDoc = self.selectedBugDoc() else {
            return
        }
        
        self.bugs = self.bugs.filter { (doc) -> Bool in
            return doc != selectedDoc
        }
        self.tableView.removeRows(at: IndexSet(integer: self.tableView.selectedRow), withAnimation: NSTableView.AnimationOptions.slideRight)
        self.setDetailInfo(doc: nil)
    }
    
    
    @IBAction func bugTitleDidEndEdit(_ sender: Any) {
        guard let selectedDoc = self.selectedBugDoc() else {
            return
        }
        selectedDoc.data.title = self.bugTitleView.stringValue
        
        let indexSet = IndexSet(integer: (self.bugs as NSArray).index(of: selectedDoc))
        let columnSet = IndexSet(integer: 0)
        self.tableView.reloadData(forRowIndexes: indexSet, columnIndexes: columnSet)
        
        
    }
    
    @IBAction func changePicture(_ sender: Any) {
        guard self.selectedBugDoc() != nil else { return }
        IKPictureTaker().beginSheet(for: self.view.window, withDelegate: self, didEnd: #selector(pictureTakerDidEnd(picker:code:contextInfo:)), contextInfo: nil)
    }
    /// 图片旋转后的回调方法
    @objc func pictureTakerDidEnd(picker: IKPictureTaker, code: Int, contextInfo: Any) {
        guard let image = picker.outputImage(), code == NSApplication.ModalResponse.OK.rawValue else {
            return
        }
        self.bugImageView.image = image
        guard let selectedBugDoc = self.selectedBugDoc() else { return }
        selectedBugDoc.fullImage = image
        selectedBugDoc.thumbImage = image.imageByScalingAndCropppingForSize(targetSize: CGSize(width: 44, height: 44))
        let indexSet = IndexSet(integer: (self.bugs as NSArray).index(of: selectedBugDoc))
        let columnSet = IndexSet(integer: 0)
        self.tableView.reloadData(forRowIndexes: indexSet, columnIndexes: columnSet)
        
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.bugs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        if tableColumn?.identifier.rawValue == "BugColumn" {
            let bugDoc = self.bugs[row]
            cellView.imageView?.image = bugDoc.thumbImage
            cellView.textField?.stringValue = bugDoc.data.title
            return cellView
        }
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        // 获取选中的数据
        guard let selectedDoc = self.selectedBugDoc() else {
            return
        }
        // 根据数据，设置详情视图内容
        self.setDetailInfo(doc: selectedDoc)
        
        self.deleteButton.isEnabled = true
        self.changePictureButton.isEnabled = true
        self.bugRating.editable = true
        self.bugTitleView.isEnabled = true
    }
}

extension ViewController: EDStarRatingProtocol {
    func starsSelectionChanged(_ control: EDStarRating, rating: Float) {
        guard let selectedDoc = self.selectedBugDoc() else { return }
        selectedDoc.data.rating = self.bugRating.rating
    }
    
    
}
