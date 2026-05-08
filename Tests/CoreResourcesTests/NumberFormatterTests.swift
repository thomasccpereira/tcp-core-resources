import Testing
import Foundation
@testable import CoreResources

@Suite("NumberFormatter tests")
struct NumberFormatterExtensionsTests {
   // MARK: - Helpers
   /// Returns the number of fraction digits in the formatted output for `value`,
   /// using the formatter’s own decimal separator. Works for currency/decimal styles.
   private func fractionDigits(of value: Double, using f: NumberFormatter) -> Int {
      let string = f.string(from: NSNumber(value: value)) ?? ""
      let decimalSeparator = f.decimalSeparator ?? Locale.current.decimalSeparator ?? "."
      guard let range = string.range(of: decimalSeparator) else { return 0 }
      return string[range.upperBound...].count
   }
   
   /// Whether the formatted output contains the grouping separator for a large number.
   private func containsGrouping(using f: NumberFormatter) -> Bool {
      let string = f.string(from: 12_345_678.9 as NSNumber) ?? ""
      guard let decimalSeparator = f.groupingSeparator, !decimalSeparator.isEmpty else { return false }
      return string.contains(decimalSeparator)
   }
   
   // MARK: - integerFormatter
   @Test func testIntegerFormatterBasics() {
      let formatter = NumberFormatter.integerFormatter
      #expect(formatter.numberStyle == .none || formatter.numberStyle == .decimal) // integer formatter typically uses decimal/none
      #expect(formatter.minimumFractionDigits == 0)
      #expect(formatter.maximumFractionDigits == 0)
      #expect(formatter.usesGroupingSeparator == true)
      
      // Round‑trip check: formatting 1234.56 should drop fractions
      #expect(fractionDigits(of: 1234.56, using: formatter) == 0)
      #expect(containsGrouping(using: formatter) == true)
   }
   
   // MARK: - currencyFormatter
   @Test func testCurrencyFormatterBasics() {
      let formatter = NumberFormatter.currencyFormatter
      #expect(formatter.numberStyle == .currency)
      #expect(formatter.minimumFractionDigits == 2)
      #expect(formatter.maximumFractionDigits == 2)
      
      // Should format something and clamp to 2 fraction digits
      #expect(formatter.string(from: 1234.567 as NSNumber) != nil)
      #expect(fractionDigits(of: 1234.567, using: formatter) == 2)
   }
   
   // MARK: - unitPriceFormatter
   @Test func testUnitPriceFormatterBasics() {
      let formatter = NumberFormatter.unitPriceFormatter
      #expect(formatter.numberStyle == .currency)
      #expect(formatter.minimumFractionDigits == 4)
      #expect(formatter.maximumFractionDigits == 4)
      
      #expect(formatter.string(from: 1.234567 as NSNumber) != nil)
      #expect(fractionDigits(of: 1.234567, using: formatter) == 4)
   }
   
   // MARK: - twoDecimalsFormatter / twoDecimalsSyncFormatter
   @Test func testTwoDecimalsFormatterBasics() {
      let formatter = NumberFormatter.twoDecimalsFormatter
      #expect(formatter.numberStyle == .decimal)
      #expect(formatter.minimumFractionDigits == 2)
      #expect(formatter.maximumFractionDigits == 2)
      #expect(containsGrouping(using: formatter) == true)
      #expect(fractionDigits(of: 12.345, using: formatter) == 2)
   }
   
   @Test func testTwoDecimalsSyncFormatterBasics() {
      let formatter = NumberFormatter.twoDecimalsSyncFormatter
      #expect(formatter.numberStyle == .decimal)
      #expect(formatter.minimumFractionDigits == 2)
      #expect(formatter.maximumFractionDigits == 2)
      #expect(formatter.usesGroupingSeparator == false)
      #expect(containsGrouping(using: formatter) == false)
      #expect(fractionDigits(of: 12.345, using: formatter) == 2)
   }
   
   // MARK: - threeDecimalsFormatter / threeDecimalsSyncFormatter
   @Test func testThreeDecimalsFormatterBasics() {
      let formatter = NumberFormatter.threeDecimalsFormatter
      #expect(formatter.numberStyle == .decimal)
      #expect(formatter.minimumFractionDigits == 3)
      #expect(formatter.maximumFractionDigits == 3)
      #expect(containsGrouping(using: formatter) == true)
      #expect(fractionDigits(of: 12.34567, using: formatter) == 3)
   }
   
   @Test func testThreeDecimalsSyncFormatterBasics() {
      let formatter = NumberFormatter.threeDecimalsSyncFormatter
      #expect(formatter.numberStyle == .decimal)
      #expect(formatter.minimumFractionDigits == 3)
      #expect(formatter.maximumFractionDigits == 3)
      #expect(formatter.usesGroupingSeparator == false)
      #expect(containsGrouping(using: formatter) == false)
      #expect(fractionDigits(of: 12.34567, using: formatter) == 3)
   }
   
   // MARK: - fourDecimalsFormatter / fourDecimalsSyncFormatter
   @Test func testFourDecimalsFormatterBasics() {
      let formatter = NumberFormatter.fourDecimalsFormatter
      #expect(formatter.numberStyle == .decimal)
      #expect(formatter.minimumFractionDigits == 4)
      #expect(formatter.maximumFractionDigits == 4)
      #expect(containsGrouping(using: formatter) == true)
      #expect(fractionDigits(of: 12.345678, using: formatter) == 4)
   }
   
   @Test func testFourDecimalsSyncFormatterBasics() {
      let formatter = NumberFormatter.fourDecimalsSyncFormatter
      #expect(formatter.numberStyle == .decimal)
      #expect(formatter.minimumFractionDigits == 4)
      #expect(formatter.maximumFractionDigits == 4)
      #expect(formatter.usesGroupingSeparator == false)
      #expect(containsGrouping(using: formatter) == false)
      #expect(fractionDigits(of: 12.345678, using: formatter) == 4)
   }
}
