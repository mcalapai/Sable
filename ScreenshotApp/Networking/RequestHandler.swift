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
    @Published var currentPrompt: String = ""
    @Published var isResponseLoading: Bool = false
    
    @Published var apiResponse: String = ""
    let image: NSImage?
    
    init(image: NSImage? = nil) {
        self.image = image
    }
    
    func makeImageRequest(image: NSImage) {
        // create api client
        //let promptModel = PromptModel.shared
        print("Current prompt is \(currentPrompt)")
        let imageReq = ImageRequest(image: image, prompt: currentPrompt)//, prompt: self.prompt)
        
        Task {
            self.isResponseLoading = true
            do {
                let apiResponse = try await imageReq.performPostRequest()
                DispatchQueue.main.async {
                    self.apiResponse = apiResponse
                    self.isResponseLoading = false
                    print("API Response: \(self.apiResponse)")
                }
            } catch {
                print("Failed to fetch: \(error.localizedDescription)")
                // Handle errors appropriately
            }
        }
    }
}
