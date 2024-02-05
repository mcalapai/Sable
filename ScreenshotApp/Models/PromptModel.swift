//
//  PromptModel.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 4/2/2024.
//

import Foundation

class PromptModel: ObservableObject {
    static let shared = PromptModel()
    
    @Published var currentPrompt: String = ""
}
