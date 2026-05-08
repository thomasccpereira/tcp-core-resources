import Foundation

public extension Optional where Wrapped == Date {
   var dateHasPassed: Bool {
      guard let date = self else { return false }
      return date <= .yesterday
   }
}
