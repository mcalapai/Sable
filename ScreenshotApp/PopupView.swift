import SwiftUI
import Combine

struct PopupView: View {
    @State private var cmdText: String = ""
    @StateObject private var promptModel = PromptModel.shared
    @FocusState private var isFocused: Bool
    @StateObject var windowManager = WindowManager.shared

    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 710, height: 45)
                    .background(Color(red: 0.40, green: 0.40, blue: 0.40))
                    .cornerRadius(10)
                    .opacity(0.60)
                    //.blendMode(.colorBurn)
                
                TextField("Enter Command Here", text: $cmdText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Font.custom("SF Pro Display", size: 18).weight(.medium))
                    .tracking(0.08)
                    .padding(15)
                    .foregroundColor(.white)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isFocused = true
                        }
                    }
                    .focused($isFocused)
                    .onSubmit {
                        windowManager.isScreenshotting = true
                        promptModel.currentPrompt = cmdText
                        cmdText = ""
                    }
            }
        }
        .frame(width: 720, height: 55)
        .background(Color(red: 0.16, green: 0.16, blue: 0.16))
        .cornerRadius(14)
    }
}

//#Preview {
//    PopupView()
//}
