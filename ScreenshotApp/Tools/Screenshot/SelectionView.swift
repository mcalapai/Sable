//
//  SelectionView.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 3/2/2024.
//

import Cocoa
import Combine
import SwiftUI
import ScreenCaptureKit

class SelectionView: NSView {
    // store the rectangles dimension
    private var selectionRect: NSRect = .zero
    @ObservedObject var windowManager = WindowManager.shared
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // set the drawing color to transparent for clearning
        NSColor.clear.set()
        dirtyRect.fill() // fill the dirtyrect with the current color to clear it
        
        // set the color for the selection rectangle
        NSColor.selectedContentBackgroundColor.set()
        // create a path for the rectangle
        
        let selectionPath = NSBezierPath(rect: selectionRect)
        selectionPath.stroke() // draw selection rectangle outline
    }
    
    // custom initialiser for the view
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // handle mouse down events
    override func mouseDown(with event: NSEvent) {
        print("is screenshotting: ", windowManager.isScreenshotting)
        guard windowManager.isScreenshotting == true else { return }
        // convert the mouse location to the view's coordinate system
        let location = self.convert(event.locationInWindow, from: nil)
        
        // set the origin of the selection rectangle to the mouse down location
        selectionRect.origin = location
    }
    
    // handle mouse dragged events to resize selection rectange
    override func mouseDragged(with event: NSEvent) {
        guard windowManager.isScreenshotting == true else { return }
        // get the current mouse location in the view's coordinates
        let currentPoint = self.convert(event.locationInWindow, from: nil)
        let origin = selectionRect.origin
        
        // calculate and update the size of the selection rectangle based on the drag
        selectionRect.size.width = currentPoint.x - origin.x
        selectionRect.size.height = currentPoint.y - origin.y
        
        //print("X origin: \(origin.x), Y origin: \(origin.y)")
        //print("Current X: \(currentPoint.x), Current Y: \(currentPoint.y)")
        
        // mark the view as needing to be redrawn
        self.needsDisplay = true
    }
    
    override func mouseUp(with event: NSEvent) {
        // check if screenshotting
        guard windowManager.isScreenshotting == true else { return }
        
        // check if prompt exists
        
        // take screenshot
        print("Screenshot triggered")
        let captureManager = ScreenCaptureManager(captureRect: selectionRect)
        Task {
            await captureManager.takeScreenshot()
            
            // destroy selection rect
            selectionRect = .zero
            self.needsDisplay = true // redraw view
            
            // set is screenshotting to false
            windowManager.isScreenshotting = false
        }
    }
}
