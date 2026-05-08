import Foundation

public extension Bool {
   // A way to compare `Bool`s.
   // Note: `false` is "less than" `true`.
   enum Comparable: CaseIterable, Swift.Comparable, Codable {
      case `false`, `true`
   }
   
   // Make a `Bool` `Comparable`, with `false` being "less than" `true`.
   var comparable: Comparable { .init(booleanLiteral: self) }
}

extension Bool.Comparable: ExpressibleByBooleanLiteral {
   public init(booleanLiteral value: Bool) {
      self = value ? .true : .false
   }
}
