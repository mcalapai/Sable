//
//  ImageRequestModel.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 4/2/2024.
//

import Foundation

struct ImageRequestModel: Codable {
    let model: String
    let messages: [Message]
    let maxTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case model, messages
        case maxTokens = "max_tokens"
    }
}

struct Message: Codable {
    let role: String
    let content: [ContentItem]
}

struct ContentItem: Codable {
    let type: String
    let text: String?
    let imageUrl: ImageURL?
    
    enum CodingKeys: String, CodingKey {
        case type, text
        case imageUrl = "image_url"
    }
}

struct ImageURL: Codable {
    let url: String
    let detail: String
    
    init(url: String, detail: String) {
        self.url = url
        self.detail = detail
    }
}
