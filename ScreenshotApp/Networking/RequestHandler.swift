//
//  RequestHandler.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 10/2/2024.
//

import Foundation
import Cocoa

class RequestHandler: ObservableObject {
    static let shared = RequestHandler()
    
    @Published var apiResponse: String = ""
    let image: NSImage?
    
    init(image: NSImage? = nil) {
        self.image = image
    }
    
    func makeImageRequest(image: NSImage) {
        // create api client
        let promptModel = PromptModel.shared
        print("Current prompt is \(promptModel.currentPrompt)")
        let imageReq = ImageRequest(image: image, prompt: promptModel.currentPrompt)//, prompt: self.prompt)
        
        
        Task {
            do {
                self.apiResponse = try await imageReq.performPostRequest()
                print("API Response: \(self.apiResponse)")
                // Update your UI or state with the obtained URL
            } catch {
                print("Failed to fetch: \(error.localizedDescription)")
                // Handle errors appropriately
            }
        }
    }
}
