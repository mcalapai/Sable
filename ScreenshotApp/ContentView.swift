//
//  ContentView.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 3/2/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var windowManager = WindowManager.shared

    var body: some View {
        ZStack {
            if windowManager.isScreenshotting {
                SelectionViewRepresentable()
            } else {
                PopupView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5)) // semi-transparent
    }
}

//#Preview {
//    ContentView()
//}
