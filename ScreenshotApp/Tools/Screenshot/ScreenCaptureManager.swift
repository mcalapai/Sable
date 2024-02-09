import ScreenCaptureKit

class ScreenCaptureManager {
    private var captureSession: SCStream? // mutable
    private let captureRect: CGRect // immutable
    //var prompt: String
    //let imageRequestor: ImageRequest
    
    init(captureRect: CGRect) {//, prompt: String) {
        self.captureRect = captureRect
        //self.prompt = prompt
        //self.imageRequestor = ImageRequest(image: nil)
    }
    
    @objc func takeScreenshot() async {
        do {
            print("Capturing screen")
            let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: false)
            guard let mainDisplayID = NSScreen.main?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID,
                  let display = content.displays.first(where: { $0.displayID == mainDisplayID }) else { return }
            
            print("Capture origin: \(captureRect.origin)")
            print("Capture final calc: (\(captureRect.origin.x + captureRect.width), \(captureRect.origin.y - captureRect.height))")
            
            let originY = 981 - captureRect.origin.y
            let adjRect = NSRect(x: captureRect.origin.x, y: originY, width: captureRect.width, height: captureRect.height)
            
            let streamConfig = SCStreamConfiguration()
            streamConfig.captureResolution = .automatic
            streamConfig.sourceRect = adjRect
            //streamConfig.height = Int(captureRect.height)*2
            //streamConfig.width = Int(captureRect.width)*2
            streamConfig.preservesAspectRatio = true
            streamConfig.scalesToFit = true
            streamConfig.capturesAudio = false
            streamConfig.excludesCurrentProcessAudio = true
            
            let filter = SCContentFilter(display: display, excludingWindows: [])
            
            let capturedImage = try await SCScreenshotManager.captureImage(contentFilter: filter, configuration: streamConfig)
            let nsImage = NSImage(cgImage: capturedImage, size:  NSZeroSize)
            
            let path = "/Users/matthewcalapai/Downloads/image.png"
            saveNSImageToFile(image: nsImage, atPath: path)
            makeImageRequest(image: nsImage)
        } catch {
            print("Error capturing screen \(error)")
        }
    }
    
    func makeImageRequest(image: NSImage) {
        // create api client
        let promptModel = PromptModel.shared
        print("Current prompt is \(promptModel.currentPrompt)")
        let imageReq = ImageRequest(image: image, prompt: promptModel.currentPrompt)//, prompt: self.prompt)
        
        do {
            try imageReq.performPostRequest()
        } catch ImageErrors.ImageNotEncoded {
            print("Image not encoded")
        } catch {
            print("Unknown error")
        }
    }
    
    
    func saveNSImageToFile(image: NSImage, atPath path: String) {
        guard let tiffRepresentation = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            print("Failed to get TIFF representation of NSImage")
            return
        }
        
        // Specify the .png format
        guard let imageData = bitmapImage.representation(using: .png, properties: [:]) else {
            print("Failed to get PNG representation of NSImage")
            return
        }
        
        do {
            // Write the image data to the file path
            try imageData.write(to: URL(fileURLWithPath: path))
            print("Image was successfully saved to \(path)")
        } catch {
            print("Failed to save image: \(error)")
        }
    }
}

