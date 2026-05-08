import Foundation

public extension String {
   func roundedDecimal(_ numberFormatter: NumberFormatter) -> Decimal {
      let number = numberFormatter.number(from: self) ?? NSNumber(value: 0.0)
      var decimal = number.decimalValue
      var roundedDecimal = Decimal()
      NSDecimalRound(&roundedDecimal, &decimal, numberFormatter.minimumFractionDigits, .plain)
      return roundedDecimal
   }
   
   var currencyValue: Double {
      let roundedDecimal = roundedDecimal(.currencyFormatter)
      let decimalNumber = NSDecimalNumber(decimal: roundedDecimal)
      return decimalNumber.doubleValue
   }
   
   var unitPriceValue: Double {
      let roundedDecimal = roundedDecimal(.unitPriceFormatter)
      let decimalNumber = NSDecimalNumber(decimal: roundedDecimal)
      return decimalNumber.doubleValue
   }
   
   var twoDecimalsValue: Double {
      let roundedDecimal = roundedDecimal(.twoDecimalsFormatter)
      let decimalNumber = NSDecimalNumber(decimal: roundedDecimal)
      return decimalNumber.doubleValue
   }
   
   // HTML-escape using **named** entities so tests can assert `&lt;`, `&gt;`, `&amp;`.
   // - Escapes: `&`, `<`, `>`, `"` (and leaves existing entities intact).
   var validHTML: String {
      var text = self.trimmed
      
      // 1) Replace '&' that are NOT already part of an entity.
      //    e.g., don't turn `&lt;` into `&amp;lt;`
      let ampPattern = #"&(?!([a-zA-Z][a-zA-Z0-9]+|#[0-9]+|#x[0-9a-fA-F]+);)"#
      if let regex = try? NSRegularExpression(pattern: ampPattern) {
         let range = NSRange(text.startIndex..<text.endIndex, in: text)
         text = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "&amp;")
      }
      
      // 2) Replace the usual suspects with named entities.
      text = text.replacingOccurrences(of: "<", with: "&lt;")
         .replacingOccurrences(of: ">", with: "&gt;")
         .replacingOccurrences(of: "\"", with: "&quot;")
         .replacingOccurrences(of: "'", with: "&#39;")
      
      return text
   }
}
