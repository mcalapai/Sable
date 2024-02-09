import Cocoa

struct AppConfig {
    static let shared = AppConfig() // Singleton instance for global access
    let openAIKey: String
    
    private init() {
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path),
           let openAIKey = keys["openAIKey"] as? String {
            self.openAIKey = openAIKey
        } else {
            fatalError("API Key not found. Ensure you have a Keys.plist with 'YourAPIKeyName'.")
        }
    }
}
