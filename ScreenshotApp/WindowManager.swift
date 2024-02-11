//
//  WindowManager.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 3/2/2024.
//

import Cocoa
import SwiftUI
import Combine

class KeyableWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}

class WindowManager: NSObject, NSWindowDelegate, ObservableObject {
    static let shared = WindowManager()
    //var currentPrompt: String?
    
    @Published var isScreenshotting: Bool
    //@Published var modelResponse: String = ""
    var isOverlayOpen: Bool?
    var overlayWindow:KeyableWindow?
    @ObservedObject var requestHandler = RequestHandler.shared
    
    // stylemask specifies the border of the window
    // backing specifies how the content is buffered
    // defer specifies when the buffering is allowed to occur
    // - setting defer: false means content is rendered instantly and not when the content is in view for the first time
    
    init(isOverlayOpen: Bool = false) {//}, currentPrompt: String = "") {
        self.isOverlayOpen = isOverlayOpen
        self.isScreenshotting = false
        //self.currentPrompt = currentPrompt
        print("Window manager init")
    }
    
    func createOverlayWindow() {
        // initialise overlay window while checking if the global overlay window exists
        // if window exists - if it does, exit this function early because its redundant
        // if overlayWindow == nil is false (i.e already initialised) then return early
        guard overlayWindow == nil else { return }
        let contentView = ContentView()
        
        // now initialise window
        let window = KeyableWindow(contentRect: NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 600, height: 400), styleMask: [.borderless, .fullSizeContentView], backing: .buffered, defer: false)
        
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.contentView = NSHostingView(rootView: contentView)
        window.level = .screenSaver // ensure the window floats above everything else
        window.isMovableByWindowBackground = false
        //window.canBecomeKey = true
        
        // make the window full screen
        window.setFrame(NSScreen.main?.frame ?? NSRect.zero, display: true)
        overlayWindow = window
    }
    
    func toggleOverlayWindow() {
        // if the window already exists
        if let window = overlayWindow {
            if window.isVisible {
                window.orderOut(nil)
                // reset api response
                requestHandler.apiResponse = ""
            } else {
                window.makeKeyAndOrderFront(nil)
            }
        } else { // else create the window
            createOverlayWindow()
            overlayWindow?.makeKeyAndOrderFront(nil)
        }
    }
}
