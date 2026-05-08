import Foundation

public extension Optional where Wrapped == Int {
   var zeroWhenNil: String {
      guard let intValue = self else { return "0" }
      return "\(intValue)"
   }
   
   var emptyWhenNil: String {
      guard let intValue = self else { return "" }
      return "\(intValue)"
   }
   
   var emptyWhenZero: String {
      guard let intValue = self, intValue > 0 else { return "" }
      return "\(intValue)"
   }
}
