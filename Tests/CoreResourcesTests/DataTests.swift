import Testing
import Foundation
import UIKit
import AVFoundation
@testable import CoreResources

@Suite("Data tests")
struct DataTests {
   @Suite("Data encoding tests")
   struct DataEncodingTests {
      @Test func testBase64Encoding() {
         let data = Data([0xde, 0xad, 0xbe, 0xef])
         #expect(data.base64 == "3q2+7w==")
      }
   }
   
   @Suite("Data image resizing tests")
   @MainActor
   struct DataImageResizingTests {
      // MARK: - Helpers
      /// Make a solid-color JPEG image of the given pixel size (scale = 1 so points == pixels).
      private func makeJPEG(width: Int, height: Int, color: UIColor = .systemBlue) -> Data {
         let size = CGSize(width: width, height: height)
         let format = UIGraphicsImageRendererFormat()
         format.scale = 1
         let img = UIGraphicsImageRenderer(size: size, format: format).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
         }
         return img.jpegData(compressionQuality: 0.95)!
      }
      
      /// Decode JPEG data to a UIImage with scale 1 so `image.size` is in pixels.
      private func decodeImage(_ data: Data) -> UIImage? {
         guard let image = UIImage(data: data) else { return nil }
         // Force scale=1 to make size comparable to renderer sizes we’re using
         return UIImage(cgImage: image.cgImage!, scale: 1, orientation: image.imageOrientation)
      }
      
      /// Computes expected target size using the same rule as the production code.
      private func expectedSize(for originalPixels: CGSize) -> CGSize {
         let maxSize = CGSize(width: 1920, height: 1080)
         let rect = AVMakeRect(aspectRatio: originalPixels, insideRect: CGRect(origin: .zero, size: maxSize))
         return rect.size
      }
      
      // MARK: - Tests
      @Test func testNonImagePassThrough() {
         let bogus = Data([0x00, 0x01, 0x02, 0x03, 0xFF])
         let out = bogus.resizedImageData
         #expect(out == bogus)
      }
      
      @Test func testLandscapeDownscale() {
         let original = makeJPEG(width: 4000, height: 2000)   // aspect 2:1
         let resized = original.resizedImageData
         
         let image = decodeImage(resized)!
         let expected = expectedSize(for: CGSize(width: 4000, height: 2000))
         
         #expect(Int(image.size.width) == Int(expected.width))
         #expect(Int(image.size.height) == Int(expected.height))
         
         // Data should change due to size + compression
         #expect(resized != original)
         // Must fit within the bounding box
         #expect(image.size.width <= 1920 && image.size.height <= 1080)
      }
      
      @Test func testPortraitDownscale() {
         let original = makeJPEG(width: 2000, height: 4000)   // aspect 1:2
         let resized = original.resizedImageData
         
         let image = decodeImage(resized)!
         let expected = expectedSize(for: CGSize(width: 2000, height: 4000))
         
         #expect(Int(image.size.width) == Int(expected.width))
         #expect(Int(image.size.height) == Int(expected.height))
         #expect(image.size.width <= 1920 && image.size.height <= 1080)
      }
      
      @Test func testSquareDownscale() {
         let original = makeJPEG(width: 3000, height: 3000)
         let resized = original.resizedImageData
         
         let image = decodeImage(resized)!
         let expected = expectedSize(for: CGSize(width: 3000, height: 3000))
         
         #expect(Int(image.size.width) == Int(expected.width))
         #expect(Int(image.size.height) == Int(expected.height))
         #expect(image.size.width == 1080 && image.size.height == 1080)
      }
      
      @Test func testSmallImageUpscalesPerRule() {
         // Note: AVMakeRect returns the largest rect of the same aspect ratio INSIDE the max box,
         // regardless of original pixel count. Your implementation will upscale smaller images.
         let original = makeJPEG(width: 800, height: 600)     // aspect 4:3
         let resized = original.resizedImageData
         
         let image = decodeImage(resized)!
         let expected = expectedSize(for: CGSize(width: 800, height: 600)) // -> 1440x1080
         
         #expect(Int(image.size.width) == Int(expected.width))
         #expect(Int(image.size.height) == Int(expected.height))
         #expect(image.size.width == 1440 && image.size.height == 1080)
      }
      
      @Test func testJPGECompressionAndValidity() {
         let original = makeJPEG(width: 2560, height: 1440)   // 16:9, will downscale to 1920x1080
         let resized = original.resizedImageData
         let image = decodeImage(resized)
         
         #expect(image != nil)
         // Compression should generally reduce size for solid fills
         #expect(resized.count < original.count || resized != original)
      }
   }
}
