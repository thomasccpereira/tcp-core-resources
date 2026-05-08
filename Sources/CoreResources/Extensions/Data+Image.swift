import AVFoundation
import SwiftUI
import Foundation

public extension Data {
   var resizedImageData: Data {
      guard let image = UIImage(data: self) else {
         return self
      }
      
      let maxSize = CGSize(width: 1920, height: 1080)
      let availableRect = AVMakeRect(aspectRatio: image.size,
                                     insideRect: .init(origin: .zero, size: maxSize))
      let targetSize = availableRect.size
      
      let format = UIGraphicsImageRendererFormat()
      format.scale = 1
      let renderer = UIGraphicsImageRenderer(size: targetSize,
                                             format: format)
      
      let resized = renderer.image { (context) in
         image.draw(in: CGRect(origin: .zero, size: targetSize))
      }
      
      guard let resizedData = resized.jpegData(compressionQuality: 0.7) else {
         return self
      }
      return resizedData
   }
}
