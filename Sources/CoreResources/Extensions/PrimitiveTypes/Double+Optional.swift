import Foundation

public extension Optional where Wrapped == Double {
   var zeroWhenNil: Double {
      guard let value = self else {
         return 0.0
      }
      return value
   }
}
