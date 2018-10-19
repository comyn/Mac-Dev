//
//  EDStarRating.swift
//  MacAppDev01
//
//  Created by ist on 2018/10/18.
//  Copyright © 2018 comyn. All rights reserved.
//

import Cocoa

let ED_DEFAULT_HALFSTAR_THRESHOLD: Float = 0.6

enum EDStarRatingDisplay : Int {
    case full = 0
    case half
    case accurate
}
typealias EDStarRatingDisplayMode = Int

@objc protocol EDStarRatingProtocol: NSObjectProtocol {
    @objc func starsSelectionChanged(_ control: EDStarRating, rating: Float)
}

class EDStarRating: NSControl {
    var backgrounColor: NSColor?
    var backgroundImage: NSImage?
    var starHighlightedImage: NSImage?
    var starImage: NSImage?
    var maxRating: Double = 0.0
    var rating: Float = 0.0
    var horizontalMargin: CGFloat = 0.0
    var editable = false
    var displayMode: EDStarRatingDisplayMode?
    var halfStarThreshold: Float = 0.0
    weak var delegate: EDStarRatingProtocol?
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        initialData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialData()
//        fatalError("init(coder:) has not been implemented")
    }
    
    func initialData() {
        // Initialization code here.
        maxRating = 5.0
        rating = 0.0
        horizontalMargin = 10.0
        displayMode = EDStarRatingDisplay.full.rawValue
        halfStarThreshold = ED_DEFAULT_HALFSTAR_THRESHOLD
    }
    
    // MARK: -
    // MARK: Setters
    func setRating(_ ratingParam: Float) {
        rating = ratingParam
        setNeedsDisplay()
    }
    func setDisplayMode(_ dispMode: EDStarRatingDisplayMode) {
        displayMode = dispMode
        setNeedsDisplay()
    }
    // MARK: -
    // MARK: Drawing
    func pointOfStar(atPosition position: CGFloat, highlighted hightlighted: Bool) -> NSPoint {
        guard let starHighlightedImage = starHighlightedImage, let starImage = starImage
        else { return NSPoint.zero }
        let size: NSSize = hightlighted ? starHighlightedImage.size : starImage.size
        let starsSpace: CGFloat = bounds.size.width - 2 * horizontalMargin
        var interSpace: CGFloat = 0
        interSpace = maxRating - 1 > 0 ? (starsSpace - size.width * CGFloat(maxRating)) / CGFloat((maxRating - 1)) : 0
        if interSpace < 0 {
            interSpace = 0
        }
        var x: CGFloat = horizontalMargin + size.width * position
        if position > 0 {
            x += CGFloat(interSpace * position)
        }
        let y: CGFloat = (bounds.size.height - size.height) / 2.0
        return NSMakePoint(x, y)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // Drawing code here.
        // Draw background color
        if let backgrounColor = backgrounColor {
            backgrounColor.set()
        } else {
            NSColor.clear.set()
        }

        let path = NSBezierPath(rect: bounds)
        path.fill()
        // Draw image background
        if let backgroundImage = backgroundImage {
            backgroundImage.draw(in: bounds, from: NSRect(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height), operation: NSCompositingOperation.sourceOver, fraction: 1.0)
        }
        if let starImage = starImage {
            let starSize: NSSize = starImage.size

            for i in 0..<Int(maxRating) {
                starImage.draw(at: pointOfStar(atPosition: CGFloat(i), highlighted: true), from: NSMakeRect(0.0, 0.0, starSize.width, starSize.height), operation: NSCompositingOperation.sourceOver, fraction: 1.0)
                if i < Int(rating) {
                    NSGraphicsContext.saveGraphicsState()
                    var pathClip: NSBezierPath? = nil
                    let starPoint: NSPoint = pointOfStar(atPosition: CGFloat(i), highlighted: false)
                    if i < Int(rating) && Int(rating) < i + 1 {
                        let difference: Float = rating - Float(i)
                        var rectClip: NSRect = NSRect(origin: starPoint, size: starSize)
                        
                        if displayMode == EDStarRatingDisplay.half.rawValue && difference < halfStarThreshold {
                            rectClip.size.width /= 2.0
                            pathClip = NSBezierPath(rect: rectClip)
                        } else if displayMode == EDStarRatingDisplay.accurate.rawValue {
                            rectClip.size.width *= CGFloat(difference)
                            pathClip = NSBezierPath(rect: rectClip)
                        }
                        if let pathClip = pathClip {
                            pathClip.addClip()
                        }
                    }
                    if let starHighlightedImage = starHighlightedImage {
                        starHighlightedImage.draw(at: starPoint, from: NSMakeRect(0.0, 0.0, starHighlightedImage.size.width, starHighlightedImage.size.height), operation: NSCompositingOperation.sourceOver, fraction: 1.0)
                    }
                    NSGraphicsContext.restoreGraphicsState()
                }
            }
        }
    }
    
    // MARK: -
    // MARK: Mouse Interaction
    func stars(for point: NSPoint) -> Float {
        var stars: Float = 0
        for i in 0..<Int(maxRating) {
            let p: NSPoint = pointOfStar(atPosition: CGFloat(i), highlighted: false)
            if point.x > p.x {
                stars = Float(i + 1)
            }
        }
        return stars
    }
    override func mouseDown(with theEvent: NSEvent) {
        if editable == false {
            return
        }
        if theEvent.type == NSEvent.EventType.leftMouseDown {
            let pointInView = convert(theEvent.locationInWindow, from: nil)
            rating = stars(for: pointInView )
            setNeedsDisplay()
        }
    }
    override func mouseDragged(with theEvent: NSEvent) {
        if editable == false {
            return
        }
        let pointInView = convert(theEvent.locationInWindow, from: nil)
        rating = Float(stars(for: pointInView))
        setNeedsDisplay()
    }
    override func mouseUp(with theEvent: NSEvent) {
        if editable == false {
            return
        }
        guard let delegate = delegate,
            delegate.responds(to: #selector(delegate.starsSelectionChanged(_:rating:))) else {
                return
        }
        delegate.starsSelectionChanged(self, rating: rating)
    }
    
    deinit {
        //        AH_RELEASE(starImage)
        //        AH_RELEASE(starHighlightedImage)
        //        AH_RELEASE(backGrounColor)
        //        AH_RELEASE(backGroundImage)
    }
}
