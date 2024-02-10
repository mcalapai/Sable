//
//  GPTRequest.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 4/2/2024.
//

import Foundation
import Cocoa

class ImageRequest: ObservableObject {
    var endpoint: URL
    var image: NSImage
    var prompt: String
    //@Published var imageReqResponse: String = ""
    
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
    
    func performPostRequest() async throws -> String {
        //guard self.image == nil else { return }i
        
        guard let b64Image = encodeImage(image: self.image) else { throw ImageErrors.ImageNotEncoded }
        
        let reqObject = ImageRequestModel(model: "gpt-4-vision-preview", messages: [
            Message(role: "user", content: [
                ContentItem(type: "text", text: self.prompt, imageUrl: nil),
                ContentItem(type: "image_url", text: nil, imageUrl: ImageURL(url: "data:image/png;base64," + b64Image, detail: "high"))
            ])
        ], maxTokens: 1000)
        
        let openAIKey = AppConfig.shared.openAIKey
        var request = URLRequest(url: self.endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(reqObject)
            // add params to body
        } catch {
            print("Error: \(error)")
            return ""
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                
                do {
                    let responseObject = try JSONDecoder().decode(ImageResponseModel.self, from: data)
                    // Use the relevant field of your decoded model. For instance, if you're returning an image URL:
                    continuation.resume(returning: responseObject.choices.first?.message.content ?? "Error")
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            task.resume()
        }
    }
}
