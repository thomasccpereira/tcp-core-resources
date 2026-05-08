import Foundation

public extension Bool {
   var nilWhenFalse: Bool? {
      self ? self : nil
   }
   
   var intValue: Int {
      NSNumber(value: self).intValue
   }
}
