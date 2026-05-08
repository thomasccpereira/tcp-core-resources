import UIKit

public extension UIColor {
   // Determines if a UIColor is dark using standard relative luminance
   var isDark: Bool {
      var red: CGFloat = 0
      var green: CGFloat = 0
      var blue: CGFloat = 0
      var alpha: CGFloat = 0
      
      guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
         return false // default to false if color components can't be extracted
      }
      
      // Calculate relative luminance
      let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
      
      return luminance < 0.5
   }
}
