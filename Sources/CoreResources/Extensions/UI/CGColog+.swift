import CoreGraphics
import UIKit

public extension CGColor {
   private func hexString(includeAlpha: Bool) -> String? {
      guard let components = self.components else { return nil }
      let colorSpace = self.colorSpace?.model
      
      var red: CGFloat = 0.0
      var green: CGFloat = 0.0
      var blue: CGFloat = 0.0
      var alpha: CGFloat = 1.0
      
      switch colorSpace {
      case .monochrome:
         red = components[0]
         green = components[0]
         blue = components[0]
         alpha = components.count > 1 ? components[1] : 1
         
      case .rgb:
         red = components[0]
         green = components[1]
         blue = components[2]
         alpha = components.count > 3 ? components[3] : 1
         
      default:
         return nil // Unsupported color space
      }
      
      let to255 = { int in Int(round(int * 255)) }
      
      if includeAlpha {
         return String(format: "#%02X%02X%02X%02X", to255(red), to255(green), to255(blue), to255(alpha))
      } else {
         return String(format: "#%02X%02X%02X", to255(red), to255(green), to255(blue))
      }
   }
   
   var hexString: String? { return self.hexString(includeAlpha: false) }
   
   var hexStringWithAlpha: String? { return self.hexString(includeAlpha: true) }
   
   var isDark: Bool { UIColor(cgColor: self).isDark }
}

