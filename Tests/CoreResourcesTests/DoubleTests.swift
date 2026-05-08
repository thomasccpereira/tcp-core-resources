import Testing
import Foundation
@testable import CoreResources

@Suite("Double tests")
struct DoubleTests {
   @Test func testZeroWhenNil() {
      let doubleA: Double? = nil
      let doubleB: Double? = 1.578
      #expect(doubleA.zeroWhenNil == 0.0)
      #expect(doubleB.zeroWhenNil == 1.578)
   }
   
   @Suite("Double rounding tests")
   struct DoubleRoundingTests {
      private func formatter(_ min: Int, _ max: Int) -> NumberFormatter {
         let formatter = NumberFormatter()
         formatter.locale = Locale(identifier: "en_US_POSIX")
         formatter.numberStyle = .decimal
         formatter.minimumFractionDigits = min
         formatter.maximumFractionDigits = max
         return formatter
      }
      
      @Test func testRoundPlain() {
         let formatter = formatter(2, 2)
         #expect(1.234.round(formatter, roundingMode: .plain) == 1.23)
         #expect(1.235.round(formatter, roundingMode: .plain) == 1.24)
         #expect((-1.235).round(formatter, roundingMode: .plain) == -1.24)
      }
      
      @Test func testRoundDown() {
         let formatter = formatter(2, 2)
         #expect(1.239.round(formatter, roundingMode: .down) == 1.23)
         #expect((-1.239).round(formatter, roundingMode: .down) == -1.24)
      }
      
      @Test func testRoundUp() {
         let formatter = formatter(2, 2)
         #expect(1.231.round(formatter, roundingMode: .up) == 1.24)
         #expect((-1.231).round(formatter, roundingMode: .up) == -1.23)
      }
      
      @Test func testRoundBankers() {
         let formatter = formatter(2, 2)
         // 12.345 -> 12.34 (even at the hundredths place)
         #expect(12.345.round(formatter, roundingMode: .bankers) == 12.34)
         // 12.355 -> 12.36 (odd becomes even)
         #expect(12.355.round(formatter, roundingMode: .bankers) == 12.36)
      }
      
      @Test func testRoundUpToPlaces() {
         #expect(1.234.roundUp() == 1.23)
         #expect(1.235.roundUp() == 1.24)
         #expect((-1.235).roundUp() == -1.24)
         #expect(1.2345.roundUp(to: 3) == 1.235)
      }
   }
   
   @Suite("Double formatting tests")
   struct DoubleFormattingTests {
      // Use the same formatters as production to avoid locale brittleness
      private func expectEqual(_ produced: String?, _ expected: String?) {
         // Some of your properties return a default like "0,00" on nil;
         // we make sure we compare non-nil strings.
         #expect((produced ?? "") == (expected ?? ""))
      }
      
      @Test func testIntegerValue() {
         let formatter = NumberFormatter.integerFormatter
         let value = 12345.678
         expectEqual(value.integerValue, formatter.string(from: NSNumber(value: value)))
      }
      
      @Test func testCurrencyValue() {
         let formatter = NumberFormatter.currencyFormatter
         let value = 1234.567
         expectEqual(value.currencyValue, formatter.string(from: NSNumber(value: value)))
      }
      
      @Test("unitCurrencyValue uses NumberFormatter.unitPriceFormatter (4 fraction digits)")
      func testUnitCurrencyValue() {
         let formatter = NumberFormatter.unitPriceFormatter
         let value = 1.234567
         expectEqual(value.unitCurrencyValue, formatter.string(from: NSNumber(value: value)))
      }
      
      @Test("twoDecimals uses NumberFormatter.twoDecimalsFormatter")
      func testTwoDecimals() {
         let formatter = NumberFormatter.twoDecimalsFormatter
         let value = 12.345
         expectEqual(value.twoDecimals, formatter.string(from: NSNumber(value: value)))
      }
      
      @Test("twoDecimalsSync uses NumberFormatter.twoDecimalsSyncFormatter (no grouping)")
      func testTwoDecimalsSync() {
         let formatter = NumberFormatter.twoDecimalsSyncFormatter
         let value = 12345.678
         expectEqual(value.twoDecimalsSync, formatter.string(from: NSNumber(value: value)))
         
         // Ensure grouping separator is absent when formatter has usesGroupingSeparator = false
         let valueString = value.twoDecimalsSync
         if let groupingSeparator = formatter.groupingSeparator, !groupingSeparator.isEmpty {
            #expect(!valueString.contains(groupingSeparator))
         }
      }
      
      @Test("threeDecimals uses NumberFormatter.threeDecimalsFormatter")
      func testThreeDecimals() {
         let formatter = NumberFormatter.threeDecimalsFormatter
         let value = 9.87654
         expectEqual(value.threeDecimals, formatter.string(from: NSNumber(value: value)))
      }
      
      @Test("threeDecimalsSync uses NumberFormatter.threeDecimalsSyncFormatter (no grouping)")
      func testThreeDecimalsSync() {
         let formatter = NumberFormatter.threeDecimalsSyncFormatter
         let value = 9876.54321
         expectEqual(value.threeDecimalsSync, formatter.string(from: NSNumber(value: value)))
         
         let valueString = value.threeDecimalsSync
         if let groupingSeparator = formatter.groupingSeparator, !groupingSeparator.isEmpty {
            #expect(!valueString.contains(groupingSeparator))
         }
      }
      
      @Test("fourDecimals uses NumberFormatter.fourDecimalsFormatter")
      func testFourDecimals() {
         let formatter = NumberFormatter.fourDecimalsFormatter
         let value = 0.123456
         expectEqual(value.fourDecimals, formatter.string(from: NSNumber(value: value)))
      }
      
      @Test("fourDecimalsSync uses NumberFormatter.fourDecimalsSyncFormatter (no grouping)")
      func testFourDecimalsSync() {
         let formatter = NumberFormatter.fourDecimalsSyncFormatter
         let value = 1234.56789
         expectEqual(value.fourDecimalsSync, formatter.string(from: NSNumber(value: value)))
         
         let valueString = value.fourDecimalsSync
         if let groupingSeparator = formatter.groupingSeparator, !groupingSeparator.isEmpty {
            #expect(!valueString.contains(groupingSeparator))
         }
      }
      
      @Test("percentualTwoDecimals appends % to twoDecimals")
      func testPercentualTwoDecimals() {
         let x = 12.345
         #expect(x.percentualTwoDecimals == "\(x.twoDecimals)%")
      }
      
      @Test("percentualThreeDecimals appends % to threeDecimals")
      func testPercentualThreeDecimals() {
         let x = 0.98765
         #expect(x.percentualThreeDecimals == "\(x.threeDecimals)%")
      }
   }
}
