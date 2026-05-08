import SwiftUI

public extension Color {
   static let lighterGray: Color = Color(.systemGray5)
   static let borderedViewColor: Color = Color("#858585")
}

public extension Color {
   // Initialize a `Color` from a hex integer (e.g., 0xFF0000 for red).
   init(hex: UInt,
        alpha: Double = 1.0) {
      
      let red   = Double((hex >> 16) & 0xFF) / 255.0
      let green = Double((hex >> 8)  & 0xFF) / 255.0
      let blue  = Double(hex & 0xFF) / 255.0
      self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
   }
   
   // Initialize a `Color` from a hex string (supports formats: `"#RRGGBB"`, `"RRGGBB"`, with optional alpha).
   init(hex: String?,
        defaultColor: Color = .black,
        alpha: Double = 1.0) {
      guard let hex else {
         self = defaultColor
         return
      }
      
      var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
         .replacingOccurrences(of: "#", with: "")
      
      // Support shorthand format (#RGB)
      if hexString.count == 3 {
         let chars = Array(hexString)
         hexString = "\(chars[0])\(chars[0])\(chars[1])\(chars[1])\(chars[2])\(chars[2])"
      }
      
      guard let hexValue = UInt64(hexString, radix: 16) else {
         self = defaultColor
         return
      }
      
      let red, green, blue, alpha: Double
      switch hexString.count {
      case 6: // RRGGBB
         red   = Double((hexValue >> 16) & 0xFF) / 255.0
         green = Double((hexValue >> 8)  & 0xFF) / 255.0
         blue  = Double(hexValue & 0xFF) / 255.0
         alpha = 1.0
      case 8: // RRGGBBAA
         red   = Double((hexValue >> 24) & 0xFF) / 255.0
         green = Double((hexValue >> 16) & 0xFF) / 255.0
         blue  = Double((hexValue >> 8)  & 0xFF) / 255.0
         alpha = Double(hexValue & 0xFF) / 255.0
      default:
         self = defaultColor
         return
      }
      
      self.init(.sRGB, red: red,
                green: green,
                blue: blue,
                opacity: alpha)
   }
   
   var hexString: String? { UIColor(self).cgColor.hexString }
   
   var hexStringWithAlpha: String? { UIColor(self).cgColor.hexStringWithAlpha }
   
   var isDark: Bool { UIColor(self).isDark }
}
