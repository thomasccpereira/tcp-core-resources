import Foundation

public extension Data {
   var base64: String? {
      self.base64EncodedString()
   }
}
