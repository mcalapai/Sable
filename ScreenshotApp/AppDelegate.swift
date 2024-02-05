//
//  AppDelegate.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 3/2/2024.
//

import Cocoa
import SwiftUI
import Carbon

var window: NSWindow! // create overlay window
var hotKeyRef: EventHotKeyRef?

let windowManager = WindowManager()

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        registerHotKey()
    }
}

func registerHotKey() {
    let hotKeyID = EventHotKeyID(signature: FourCharCode("swft".fourCharCodeValue), id: UInt32(1))
    var gHotKeyRef: EventHotKeyRef?
    // Define the event type for a hotkey event
    var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: OSType(kEventHotKeyPressed))
    InstallEventHandler(GetApplicationEventTarget(), { (handlerCallRef, event, userData) -> OSStatus in
        print("Hotkey pressed")
        // perform action here
        DispatchQueue.main.async {
            windowManager.toggleOverlayWindow()
        }
        return noErr
    }, 1, &eventType, nil, nil)
    
    RegisterEventHotKey(UInt32(kVK_ANSI_P), UInt32(cmdKey | optionKey), hotKeyID, GetApplicationEventTarget(), 0, &gHotKeyRef)
}

extension String {
    // Helper extension to convert a string to a FourCharCode which is used in Carbon for event hotkey signatures
    var fourCharCodeValue: FourCharCode {
        return self.utf8.reduce(0) { (result, character) in
            return (result << 8) + FourCharCode(character)
        }
    }
}
