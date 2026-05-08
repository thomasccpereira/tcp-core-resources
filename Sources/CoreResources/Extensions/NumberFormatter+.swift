import Foundation

// MARK: - Number format
public extension NumberFormatter {
   static var integerFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.usesGroupingSeparator = true
      formatter.usesSignificantDigits = false
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 0
      return formatter
   }
   
   static var currencyFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .currency
      formatter.minimumFractionDigits = 2
      formatter.maximumFractionDigits = 2
      return formatter
   }
   
   static var unitPriceFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .currency
      formatter.minimumFractionDigits = 4
      formatter.maximumFractionDigits = 4
      return formatter
   }
   
   static var twoDecimalsFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .decimal
      formatter.minimumFractionDigits = 2
      formatter.maximumFractionDigits = 2
      return formatter
   }
   
   static var twoDecimalsSyncFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .decimal
      formatter.usesGroupingSeparator = false
      formatter.minimumFractionDigits = 2
      formatter.maximumFractionDigits = 2
      return formatter
   }
   
   static var threeDecimalsFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .decimal
      formatter.minimumFractionDigits = 3
      formatter.maximumFractionDigits = 3
      return formatter
   }
   
   static var threeDecimalsSyncFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .decimal
      formatter.usesGroupingSeparator = false
      formatter.minimumFractionDigits = 3
      formatter.maximumFractionDigits = 3
      return formatter
   }
   
   static var fourDecimalsFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .decimal
      formatter.minimumFractionDigits = 4
      formatter.maximumFractionDigits = 4
      return formatter
   }
   
   static var fourDecimalsSyncFormatter: NumberFormatter {
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .decimal
      formatter.usesGroupingSeparator = false
      formatter.minimumFractionDigits = 4
      formatter.maximumFractionDigits = 4
      return formatter
   }
}
