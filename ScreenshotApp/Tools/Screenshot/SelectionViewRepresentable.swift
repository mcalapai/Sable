//
//  SelectionViewRepresentable.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 3/2/2024.
//

import SwiftUI

struct SelectionViewRepresentable: NSViewRepresentable {
    // create and return an instance of the selectionview
    func makeNSView(context: Context) -> SelectionView {
        print("init")
        return SelectionView()
    }
    
    func updateNSView(_ nsView: SelectionView, context: Context) {
        // perform updates to NSView here
    }
}
