//
//  NSImage+Extenstion.swift
//  MacAppDev01
//
//  Created by ist on 2018/10/18.
//  Copyright © 2018 comyn. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    func imageByScalingAndCropppingForSize(targetSize: CGSize) -> NSImage? {
        let sourceImage = self
        var newImage: NSImage? = nil
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidht = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaleWidth = targetWidht
        var scaleHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if !imageSize.equalTo(targetSize) {
            let widhtFactor = targetWidht / width
            let heightFactor = targetHeight / height
            if widhtFactor > heightFactor {
                scaleFactor = widhtFactor // scale to fit height
            } else {
                scaleFactor = heightFactor // scale to fit widht
            }
            
            scaleWidth = ceil(width * scaleFactor)
            scaleHeight = ceil(height * scaleFactor)
            
            // center the image
            if widhtFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaleHeight) * 0.5
            } else if widhtFactor < heightFactor {
                thumbnailPoint.x = (targetWidht - scaleWidth) * 0.5
            }
        }
        newImage = NSImage(size: NSSize(width: scaleWidth, height: scaleHeight))
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaleWidth
        thumbnailRect.size.height = scaleHeight
        
        let imageRect = NSRect(x: 0.0, y: 0.0, width: imageSize.width, height: imageSize.height)
        
        newImage?.lockFocus()
        self.draw(in: thumbnailRect, from: imageRect, operation: NSCompositingOperation.copy, fraction: 1.0)
        newImage?.unlockFocus()
        
        return newImage
    }
}
