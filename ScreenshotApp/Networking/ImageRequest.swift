//
//  GPTRequest.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 4/2/2024.
//

import Foundation
import Cocoa

class ImageRequest {
    var endpoint: URL
    var image: NSImage
    var prompt: String
    
    init(image: NSImage, prompt: String) {
        self.endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!
        self.image = image
        self.prompt = prompt
    }
    
    private func encodeImage(image: NSImage) -> String? {
        guard let cgRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let bitmapRep = NSBitmapImageRep(cgImage: cgRef)
        
        // get png or jpeg data from NSBitmapImageRep
        guard let imageData = bitmapRep.representation(using: .png, properties: [:]) else {
            return nil
        }
        
        // encode to b64
        let base64String = imageData.base64EncodedString()
        return base64String
    }
    
    func performPostRequest() throws {
        //guard self.image == nil else { return }i
        
        guard let b64Image = encodeImage(image: self.image) else { throw ImageErrors.ImageNotEncoded }
        
        let reqObject = ImageRequestModel(model: "gpt-4-vision-preview", messages: [
            Message(role: "user", content: [
                ContentItem(type: "text", text: self.prompt, imageUrl: nil),
                ContentItem(type: "image_url", text: nil, imageUrl: ImageURL(url: "data:image/png;base64," + b64Image, detail: "high"))
            ])
        ], maxTokens: 1000)
        
        var request = URLRequest(url: self.endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(reqObject)
            // add params to body
        } catch {
            print("Error: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Handle successful response
                do {
                    // Assuming you want to parse the JSON response
                    let responseObject = try JSONDecoder().decode(ImageResponseModel.self, from: data)
                    print("Response: \(responseObject)")
                } catch {
                    print("Failed to decode response: \(error)")
                }
            } else {
                // Handle server errors or other status codes
                print("Server returned an error")
            }
        }

        task.resume()
    }
}
