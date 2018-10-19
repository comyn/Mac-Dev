//
//  ViewController.swift
//  CollectionDemo
//
//  Created by ist on 2018/10/19.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var collecitonView: NSCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        initialCollectionView()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
// 设置重用标识
fileprivate  let reusedKey = "demoItem"

extension ViewController {
    fileprivate func initialCollectionView() {
        // 注册item
        collecitonView.register(CustomItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: reusedKey))
        // 设置数据源
        collecitonView.dataSource = self
        // 获取布局
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collecitonView.collectionViewLayout = flowLayout
        
        
    }
}

extension ViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return collecitonView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: reusedKey), for: indexPath)
    }
}
extension ViewController: NSCollectionViewDelegate {
    
}
