//
//  PopupViewNew.swift
//  ScreenshotApp
//
//  Created by Matthew Calapai on 10/2/2024.
//

import SwiftUI

struct PopupView: View {
    @State private var cmdText: String = ""
    //@StateObject private var promptModel = PromptModel.shared
    @FocusState private var isFocused: Bool
    @StateObject var windowManager = WindowManager.shared
    @ObservedObject var requestHandler = RequestHandler.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
          HStack(spacing: 0) {
              TextField("Enter text here", text: $cmdText)
                  .textFieldStyle(PlainTextFieldStyle())
                  .font(Font.custom("SF Pro Display", size: 18).weight(.medium))
                  .tracking(0.08)
                  .foregroundColor(.white)
                  .onAppear {
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                          self.isFocused = true
                      }
                  }
                  .focused($isFocused)
                  .onSubmit {
                      windowManager.isScreenshotting = true
                      requestHandler.currentPrompt = cmdText
                      cmdText = ""
                  }
          }
            
          .padding(EdgeInsets(top: 12, leading: 15, bottom: 12, trailing: 15))
          .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
          .background(Color(red: 0.08, green: 0.08, blue: 0.08))
          .cornerRadius(10)
            if (requestHandler.apiResponse != "" || requestHandler.isResponseLoading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Response")
                        .font(Font.custom("SF Pro Display", size: 12).weight(.medium))
                        .tracking(0.08)
                        .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
                        .frame(maxWidth: .infinity)
                    ScrollView {
                        VStack {
                            if (requestHandler.isResponseLoading) {
                                Text("Loading...")
                                    .font(Font.custom("SF Pro Display", size: 16).weight(.medium))
                                    .tracking(0.08)
                                    .foregroundColor(.white)
                            } else {
                                Text(requestHandler.apiResponse)
                                    .font(Font.custom("SF Pro Display", size: 16).weight(.medium))
                                    .tracking(0.08)
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    
                }
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .frame(width: 710)
                .cornerRadius(10)
            }
        }
        .padding(5)
        .frame(width: 720)
        .background(Color(red: 0.16, green: 0.16, blue: 0.16))
        .cornerRadius(14)
    }
}

#Preview {
    PopupViewNew()
}
