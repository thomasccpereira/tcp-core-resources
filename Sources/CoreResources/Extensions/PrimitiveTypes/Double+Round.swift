import Foundation

public extension Double {
   func round(_ numberFormatter: NumberFormatter, roundingMode: NSDecimalNumber.RoundingMode = .plain) -> Double {
      var decimal = NSDecimalNumber(value: self).decimalValue
      var roundedDecimal = NSDecimalNumber().decimalValue
      NSDecimalRound(&roundedDecimal, &decimal, numberFormatter.minimumFractionDigits, roundingMode)
      return NSDecimalNumber(decimal: roundedDecimal).doubleValue
   }
   
   func roundUp(to places: Int = 2) -> Double {
      let multiplier = pow(10.0, Double(places))
      return (self * multiplier).rounded() / multiplier
   }
}
