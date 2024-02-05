//
//  ImageResponseModel.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 4/2/2024.
//

import Foundation

struct ImageResponseModel: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
    
    enum CodingKeys: String, CodingKey {
        case id, object, created, model, usage, choices
    }
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct Choice: Codable {
    let message: ResponseMessage
    let finishReason: String
    let index: Int
    
    enum CodingKeys: String, CodingKey {
        case message, index
        case finishReason = "finish_reason"
    }
}

struct ResponseMessage: Codable {
    let role: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case role, content
    }
}
